require_relative '../../spec_helper'

shared_examples_for "reads contracts based on access" do
  let(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
  let(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
  subject { get :index, {} }
  before(:each) do
    @user = one_user
    FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
    add_jwt_header(request, @user)
  end

  it "returns a success response if login." do
    subject
    expect(response).to have_http_status(:success)
  end

  it "returns correct number of contracts." do
    # There should be 2 contracts inside the database, and the user can only access one of them.
    subject
    result = assigns(:contracts)
    expect(result.count).to eq(1)
    expect(result).to include(contract1)
    expect(result).not_to include(contract2)
  end

  it "returns correct json of contracts." do
    subject
    result = JSON.parse(response.body)[0]
    expect(result['name']).to eq('Nasa')
    expect(result['status']).to eq('draft')
  end
end


shared_examples_for "reads contract by id based on access" do
  let(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
  let(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
  before(:each) do
    @user = one_user
    FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
    add_jwt_header(request, @user)
  end

  it "returns a success response if the use has access to contract1." do
    get :show, params: {:id => contract1.id}
    expect(response).to have_http_status(:success)
  end

  it "returns contract1." do
    # There should be 2 road_orders inside the database, and the user can only access one of them.
    get :show, params: {:id => contract1.id}
    result = assigns(:contract)
    expect(result).to eq(contract1)
  end

  it "fails to access to contract2" do
    expect { get :show, params: {:id => contract2.id} }.to raise_error(CanCan::AccessDenied)
  end
end

shared_examples_for "has no ability for this action" do
  before(:each) do
    @user = one_user
    add_jwt_header(request, @user)
  end
  it "fails to do this action" do
    expect { subject }.to raise_error(CanCan::AccessDenied)
  end
end

shared_examples_for "reads stations based on contract access" do
  let!(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status => "draft") }
  let!(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status => "open") }
  let!(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "King") }
  let!(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "Queen") }
  before(:each) do
    @user = one_user
    FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
    add_jwt_header(request, @user)
  end

  it "returns a success response if the use has access to contract1." do
    get :index, params: {}
    expect(response).to have_http_status(:success)
  end

  it "returns correct number of stations." do
    # There should be 2 road_orders inside the database, and the user can only access one of them.
    get :index, params: {}
    result = assigns(:stations)
    expect(result.count).to eq(1)
    expect(result).to include(station1)
    expect(result).not_to include(station2)

  end

  it "returns correct json of stations." do
    get :index, params: {}
    result = JSON.parse(response.body)[0]
    expect(result['name']).to eq('King')
    expect(result['contract_id']).to eq(contract1.id)
  end
end

shared_examples_for "reads station by id based on contract access" do
  let(:contract1) { FactoryBot.create(:contract, :name => "Nasa", :status=> "draft") }
  let(:contract2) { FactoryBot.create(:contract, :name => "Tesla", :status=> "open") }
  let(:station1) { FactoryBot.create(:station, :contract_id => contract1.id, :name => "King") }
  let(:station2) { FactoryBot.create(:station, :contract_id => contract2.id, :name => "Queen") }
  before(:each) do
    @user = one_user
    FactoryBot.create(:access, :contract_id => contract1.id, :user_id => @user.id)
    add_jwt_header(request, @user)
  end

  it "returns a success response if the use has access to contract1." do
    get :show, params: {:id => station1.id}
    expect(response).to have_http_status(:success)
  end

  it "returns station1." do
    # There should be 2 road_orders inside the database, and the user can only access one of them.
    get :show, params: {:id => station1.id}
    result = assigns(:station)
    expect(result).to eq(station1)
  end

  it "fails to access to contract2" do
    expect { get :show, params: {:id => station2.id} }.to raise_error(CanCan::AccessDenied)
  end
end