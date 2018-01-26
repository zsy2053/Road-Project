require_relative '../../spec_helper'

shared_examples_for "reads back_order by id based on access" do
  let!(:contract1) { FactoryBot.create(:contract, :name => "contract 1") }
  let!(:contract2) { FactoryBot.create(:contract, :name => "contract 2") }
  let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "station 1") }
  let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "station 2") }
  let!(:back_order1) { FactoryBot.create(:back_order, :station_id => station1.id, :contract_id => contract1.id) }
  let!(:back_order2) { FactoryBot.create(:back_order, :station_id => station2.id, :contract_id => contract2.id) }
  
  before(:each) do
    @user = user
    FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
    add_jwt_header(request, @user)
  end

  it "returns a success response if the user has access to contract1" do
    get :show, params: {:id => back_order1.id}
    expect(response).to have_http_status(:success)
  end

  it "returns back_order1" do
    # There should be 2 back orders inside the database, and the user can only access one of them.
    get :show, params: {:id => back_order1.id}
    result = assigns(:back_order)
    expect(result).to eq(back_order1)
  end

  it "fails to access to back_order2" do
    get :show, params: {:id => back_order2.id}
    expect(response).to have_http_status(:forbidden)
  end
end