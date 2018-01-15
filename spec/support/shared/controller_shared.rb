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

  it "returns correct number of road order." do
    # There should be 2 road_orders inside the database, and the user can only access one of them.
    subject
    result = assigns(:contracts)
    expect(result.count).to eq(1)
    expect(result).to include(contract1)
    expect(result).not_to include(contract2)
  end

  it "returns correct json of road order join with station and contract." do
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