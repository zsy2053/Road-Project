require 'rails_helper'

RSpec.describe BackOrdersController, type: :controller do
  
  describe "GET #index" do
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:station1a) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1a") }
    let!(:station1b) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1b") }
    let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
    let!(:back_order1a) { FactoryBot.create(:back_order, :station_id => station1a.id, :contract_id => contract1.id) }
    let!(:back_order1b) { FactoryBot.create(:back_order, :station_id => station1b.id, :contract_id => contract1.id) }
    let!(:back_order2) { FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id) }
  
    subject { get :index, {} }
    
    context "for anonymous user" do
      it "returns a failed response without login" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for planner with access to only one contract" do
      before(:each) do
        @planner = FactoryBot.create(:method_engineer_user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @planner.id)
        add_jwt_header(request, @planner)
      end

      it "returns a success response if login" do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of back order" do
        # There should be three back_orders inside the database, and the user can only access two of them.
        subject
        result = assigns(:back_orders)
        expect(result.count).to eq(2)
        expect(result).to include(back_order1a)
        expect(result).to include(back_order1b)
        expect(result).not_to include(back_order2)
      end
      
      it "returns correct number of back orders when filtering by station" do
        # There should be three back_orders inside the database, and the user should only see
        # the ones for the requested station.
        get :index, params: { :station_id => station1a.id }
        result = assigns(:back_orders)
        expect(result.count).to eq(1)
        expect(result).to include(back_order1a)
        expect(result).not_to include(back_order1b)
        expect(result).not_to include(back_order2)
      end
    end

    context "for planner with access to contracts" do
      before(:each) do
        @planner = FactoryBot.create(:method_engineer_user)
        FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @planner.id)
        FactoryBot.create(:access, :contract_id => contract2.id, :user_id => @planner.id)
        add_jwt_header(request, @planner)
      end

      it "returns a success response if login" do
        subject
        expect(response).to have_http_status(:success)
      end

      it "returns correct number of back order" do
        # There should be three back_orders inside the database, and the user can only access all of them.
        subject
        result = assigns(:back_orders)
        expect(result.count).to eq(3)
        expect(result).to include(back_order1a)
        expect(result).to include(back_order1b)
        expect(result).to include(back_order2)
      end
      
      it "returns correct number of back orders when filtering by station" do
        # There should be three back_orders inside the database, and the user should only see
        # the ones for the requested station.
        get :index, params: { :station_id => station1a.id }
        result = assigns(:back_orders)
        expect(result.count).to eq(1)
        expect(result).to include(back_order1a)
        expect(result).not_to include(back_order1b)
        expect(result).not_to include(back_order2)
      end
    end
  end
  
  describe "POST create" do
    let(:station) { FactoryBot.create(:station) }
    let(:author) { FactoryBot.create(:user) }
    let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
    let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
    let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
    let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
         
    let(:valid_attributes) {
      [{
        "station_id" => station1.id,
        "station_name" => station1.name,
        "contract_id" => contract1.id,
        "bom_exp_no" => "bom_exp_no",
        'mrp_cont' => "mrp_cont",
        "cri" => true,
        "component" => "component",
        "material_description" => "material_description",
        "sort_string" => "sort_string",
        "assembly" => "assembly",
        "order" => "order",
        "item_text_line_1" => "item_text_line_1",
        "qty" => 0,
        "vendor_name" => "vendor_name",
        "focused_part_flag" => true
      }]
    }
    
    let(:valid_attributes_list){[
      {
        "station_id" => station1.id,
        "station_name" => station1.name,
        "contract_id" => contract1.id,
        "bom_exp_no" => "1 bom_exp_no",
        'mrp_cont' => "1 mrp_cont",
        "cri" => true,
        "component" => "1 component",
        "material_description" => "1 material_description",
        "sort_string" => "1 sort_string",
        "assembly" => "1 assembly",
        "order" => "1 order",
        "item_text_line_1" => "1 item_text_line_1",
        "qty" => 1,
        "vendor_name" => "1 vendor_name",
        "focused_part_flag" => true
      }, {
        "station_id" => station1.id,
        "station_name" => station1.name,
        "contract_id" => contract1.id,
        "bom_exp_no" => "2 bom_exp_no",
        "mrp_cont" => "2 mrp_cont",
        "cri" => true,
        "component" => "2 component",
        "material_description" => "2 material_description",
        "sort_string" => "2 sort_string",
        "assembly" => "2 assembly",
        "order" => "2 order",
        "item_text_line_1" => "2 item_text_line_1",
        "qty" => 2,
        "vendor_name" => "2 vendor_name",
        "focused_part_flag" => true
      }        
    ]}
    
    let(:invalid_attributes) { [{ apple: 'banana' }] }
    
    context "for anonymous user" do
      it "returns a failed response without login" do
        put :create, params: {back_order: valid_attributes}
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context "for authenticated user" do
      before(:each) do
        @user = author
        add_jwt_header(request, @user)
        
        @ability = Ability.new(@user)
        expect(@controller).to receive(:current_ability).and_return(@ability)
      end
      
      describe "with access" do
        describe "with one back order to create" do
          it "should delete previous back orders before createing the new one" do
            back_order1 = FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            put :create, params: { back_orders: valid_attributes }
            
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            
            back_orders = BackOrder.all
            
            expect(back_orders[0].attributes.except("updated_at", "created_at")).to eq(back_order2.attributes.except("updated_at", "created_at"))
            expect(back_orders[1].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes[0].except('station_name'))
            
            result = assigns(:back_orders)
            expect(result[:errors]).to be_blank
            
            expect(result[:back_orders].size).to eq(1)
            expect(result[:back_orders][back_orders[1].id].except!(:contract_name, :station_name)).to eq(back_orders[1].as_json.except!(:id))
          end
          
          it "should just create a new back order if there are no other back orders for this contract" do
            back_order = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            put :create, params: {back_orders: valid_attributes}
            
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            
            back_orders = BackOrder.all
            
            expect(back_orders[0].attributes.except("updated_at", "created_at")).to eq(back_order.attributes.except("updated_at", "created_at"))
            expect(back_orders[1].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes[0].except('station_name'))
            
            result = assigns(:back_orders)
            expect(result[:errors]).to be_blank
            
            expect(result[:back_orders].size).to eq(1)
            expect(result[:back_orders][back_orders[1].id].except!(:contract_name, :station_name)).to eq(back_orders[1].as_json.except!(:id))
          end
          
          it "rejects invalid input" do
            @ability.can :create, BackOrder
            
            post :create, params: { back_orders: invalid_attributes }
            
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to eq('application/json')
            
            result = JSON.parse(response.body)
            expect(result.count).to eq(1)
          end
        end
        
        describe "with more than one back order to create" do
          it "should delete previous back orders before createing new ones" do
            back_order1 = FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            put :create, params: { back_orders: valid_attributes_list }
            
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            
            back_orders = BackOrder.all
            
            expect(back_orders.length).to eq(3)
            expect(back_orders[0].attributes.except("updated_at", "created_at")).to eq(back_order2.attributes.except("updated_at", "created_at"))
            expect(back_orders[1].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes_list[0].except('station_name'))
            expect(back_orders[2].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes_list[1].except('station_name'))
            
            result = assigns(:back_orders)
            expect(result[:errors]).to be_blank
            
            expect(result[:back_orders].size).to eq(2)
            expect(result[:back_orders][back_orders[1].id].except(:contract_name, :station_name)).to eq(back_orders[1].as_json.except(:id))
            expect(result[:back_orders][back_orders[2].id].except(:contract_name, :station_name)).to eq(back_orders[2].as_json.except(:id))
          end
          
          it "should just create a new back order if there are no other back orders for this contract" do
            back_order = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            @ability.can :create, BackOrder
            
            put :create, params: {back_orders: valid_attributes_list}
            
            expect(response).to have_http_status(:created)
            expect(response.content_type).to eq('application/json')
            
            back_orders = BackOrder.all
            
            expect(back_orders.length).to eq(3)
            expect(back_orders[0].attributes.except("updated_at", "created_at")).to eq(back_order.attributes.except("updated_at", "created_at"))
            expect(back_orders[1].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes_list[0].except('station_name'))
            expect(back_orders[2].attributes.except("id", "updated_at", "created_at")).to eq(valid_attributes_list[1].except('station_name'))
            
            result = assigns(:back_orders)
            expect(result[:errors]).to be_blank
            
            expect(result[:back_orders].size).to eq(2)
            expect(result[:back_orders][back_orders[1].id].except(:contract_name, :station_name)).to eq(back_orders[1].as_json.except(:id))
            expect(result[:back_orders][back_orders[2].id].except(:contract_name, :station_name)).to eq(back_orders[2].as_json.except(:id))
          end
          
          it "should return an error if not all back orders in the list have station_name" do
            invalid_attributes_list = [{
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "cri" => true,
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "station_name" => station1.name
            }, {
              "contract_id" => contract1.id,
              "bom_exp_no" => "2 bom_exp_no",
              "mrp_cont" => "2 mrp_cont",
              "cri" => true,
              "component" => "2 component",
              "material_description" => "2 material_description",
              "sort_string" => "2 sort_string",
              "assembly" => "2 assembly",
              "order" => "2 order",
              "item_text_line_1" => "2 item_text_line_1",
              "qty" => 2,
              "vendor_name" => "2 vendor_name",
              "focused_part_flag" => true
            }]
            
            back_order1 = FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            pre_create_list = BackOrder.all
            
            expect(pre_create_list).to eq([back_order1, back_order2])
            
            put :create, params: {back_orders: invalid_attributes_list}
            
            expect(response).to have_http_status(:unprocessable_entity)
            
            errors = assigns(:back_orders)[:errors]
            expect(errors.length).to eq(1)
            expect(errors[0]).to be_blank
            expect(errors[1].messages).to eq({station: ['must exist']})
            
            post_create_list = BackOrder.all
            
            expect(post_create_list).to eq(pre_create_list)
          end
          
          it "should return an error if not all back orders in the list have station_name values that exist" do
            invalid_attributes_list = [{
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "cri" => true,
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "station_name" => station1.name
            }, {
              "contract_id" => contract1.id,
              "bom_exp_no" => "2 bom_exp_no",
              "mrp_cont" => "2 mrp_cont",
              "cri" => true,
              "component" => "2 component",
              "material_description" => "2 material_description",
              "sort_string" => "2 sort_string",
              "assembly" => "2 assembly",
              "order" => "2 order",
              "item_text_line_1" => "2 item_text_line_1",
              "qty" => 2,
              "vendor_name" => "2 vendor_name",
              "focused_part_flag" => true,
              "station_name" => 'bdbdf'
            }]
            
            back_order1 = FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            pre_create_list = BackOrder.all
            
            expect(pre_create_list).to eq([back_order1, back_order2]) 
            
            put :create, params: {back_orders: invalid_attributes_list}
            
            expect(response).to have_http_status(:unprocessable_entity)
            errors = assigns(:back_orders)[:errors]
            expect(errors.length).to eq(1)
            expect(errors[0]).to be_blank
            expect(errors[1].messages).to eq(:station => ['must match'])
            
            post_create_list = BackOrder.all
            
            expect(post_create_list).to eq(pre_create_list)
          end
          
          it "should return an error if not all back orders in the list belong to the same contract" do
            invalid_attributes_list = [{
              "station_id" => station1.id,
              "station_name" => station1.name,
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "cri" => true,
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true
            }, {
              "station_id" => station1.id,
              "station_name" => station1.name,
              "contract_id" => contract2.id,
              "bom_exp_no" => "2 bom_exp_no",
              "mrp_cont" => "2 mrp_cont",
              "cri" => true,
              "component" => "2 component",
              "material_description" => "2 material_description",
              "sort_string" => "2 sort_string",
              "assembly" => "2 assembly",
              "order" => "2 order",
              "item_text_line_1" => "2 item_text_line_1",
              "qty" => 2,
              "vendor_name" => "2 vendor_name",
              "focused_part_flag" => true
            }]
            
            back_order1 =FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            pre_create_list = BackOrder.all
            
            expect(pre_create_list).to eq([back_order1, back_order2]) 
            
            put :create, params: {back_orders: invalid_attributes_list}
            
            expect(response).to have_http_status(:unprocessable_entity)
            errors = assigns(:back_orders)[:errors]
            expect(errors.length).to eq(1)
            expect(errors[0]).to be_blank
            expect(errors[1].messages).to eq(:contract => ['must match'])
            
            post_create_list = BackOrder.all
            
            expect(post_create_list).to eq(pre_create_list)
          end
          
          it "should return an error if contract_id is missing as an attribute" do
            invalid_attributes_list = [{
              "station_id" => station1.id,
              "station_name" => station1.name,
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "cri" => true
            }, {
              "station_id" => station1.id,
              "station_name" => station1.name,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "cri" => true
            }]
            
            back_order1 =FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            pre_create_list = BackOrder.all
            
            expect(pre_create_list).to eq([back_order1, back_order2]) 
             
            put :create, params: {back_orders: invalid_attributes_list}
            
            expect(response).to have_http_status(:unprocessable_entity)
            errors = assigns(:back_orders)[:errors]
            expect(errors.length).to eq(1)
            expect(errors[0]).to be_blank
            expect(errors[1].messages).to eq(:contract => ['must exist'])
            
            post_create_list = BackOrder.all
            
            expect(post_create_list).to eq(pre_create_list)        
          end
          
          it "should return an error if any attribute other than contract_id is missing" do
            invalid_attributes_list = [{
              "station_id" => station1.id,
              "station_name" => station1.name,
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "cri" => true
            }, {
              "contract_id" => contract1.id,
              "bom_exp_no" => "1 bom_exp_no",
              'mrp_cont' => "1 mrp_cont",
              "component" => "1 component",
              "material_description" => "1 material_description",
              "sort_string" => "1 sort_string",
              "assembly" => "1 assembly",
              "order" => "1 order",
              "item_text_line_1" => "1 item_text_line_1",
              "qty" => 1,
              "vendor_name" => "1 vendor_name",
              "focused_part_flag" => true,
              "cri" => true
            }]
            
            back_order1 =FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id)
            back_order2 = FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id)
            
            @ability.can :create, BackOrder
            
            pre_create_list = BackOrder.all
            
            expect(pre_create_list).to eq([back_order1, back_order2]) 
            
            put :create, params: {back_orders: invalid_attributes_list}
            
            expect(response).to have_http_status(:unprocessable_entity)
            errors = assigns(:back_orders)[:errors]
            expect(errors.length).to eq(1)
            expect(errors[0]).to be_blank
            expect(errors[1].messages).to eq(:station => ['must exist'])
            
            post_create_list = BackOrder.all
            
            expect(post_create_list).to eq(pre_create_list) 
          end
        end     
      end
      
      describe "without access" do
        it "fails" do
          @ability.cannot :create, BackOrder
          post :create, params: { back_orders: valid_attributes }
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
  
  describe "GET #show" do
    context "for anonymous user" do
      it "returns a failed response without login" do
        back_order = FactoryBot.create(:back_order)
        get :show, params: { :id => back_order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "for Method Engineer" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:method_engineer_user) }
      end
    end

    context "for Supervisor" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:supervisor_user) }
      end
    end

    context "for planner" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:planner_user) }
      end
    end

    context "for station" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:station_user) }
      end
    end

    context "for quality" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:quality_user) }
      end
    end

    context "for admin" do
      it_behaves_like "reads back_order by id based on access" do
        let(:user) { FactoryBot.create(:admin_user) }
      end
    end

    context "for super_admin" do
      let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
      let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
      let!(:back_order1) { FactoryBot.create(:back_order, contract: contract1) }
      let!(:back_order2) { FactoryBot.create(:back_order, contract: contract2) }
      before(:each) do
        @user = FactoryBot.create(:super_admin_user)
        add_jwt_header(request, @user)
      end

      it "returns back_order1" do
        get :show, params: { :id => back_order1.id }
        result = assigns(:back_order)
        expect(result).to eq(back_order1)
      end

      it "returns back_order2" do
        get :show, params: { :id => back_order2.id }
        result = assigns(:back_order)
        expect(result).to eq(back_order2)
      end
    end
  end
end
