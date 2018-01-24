require 'rails_helper'

RSpec.describe AccessesController, type: :controller do
	describe "#Create" do
		let(:user) { FactoryBot.create(:supervisor_user) }
		let(:contract) { FactoryBot.create(:contract) }
		subject { post :create, params: { :access => { :contract_id => contract.id, :user_id => user.id } } }
		
		before(:each) do
		  @user = FactoryBot.create(:super_admin_user)
		  add_jwt_header(request, @user)
		end

		it "can create access" do
			subject
			expect(response).to be_success
		end
	end

	describe "delete" do
		let!(:access) { FactoryBot.create(:access) }
		subject { delete :destroy, params: { :id => access.id } }

		before(:each) do
		  @user = FactoryBot.create(:super_admin_user)
		  add_jwt_header(request, @user)
		end

		it "can delete access" do
			expect{ subject }.to change(Access, :count).by(-1)
		end
	end
end
