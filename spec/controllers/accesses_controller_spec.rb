require 'rails_helper'

RSpec.describe AccessesController, type: :controller do

	describe "#Create" do
		let(:user) { FactoryBot.create(:supervisor_user) }
		let(:contract) { FactoryBot.create(:contract) }
		subject { post :create, params: { :access => { :contract_id => contract.id, :user_id => user.id } } }
		
		context "super admin" do
			before(:each) do
			  @user = FactoryBot.create(:super_admin_user)
			  add_jwt_header(request, @user)
			end

			it "can create access" do
				subject
				expect(response).to be_success
			end
		end
	end

	describe "POST # multi_update" do
		let(:user1){FactoryBot.create(:station_user)}
		let(:user2){FactoryBot.create(:station_user)}
		let(:user3){FactoryBot.create(:station_user)}
		let(:contract){FactoryBot.create(:contract)}

		context "super admin" do
			before(:each) do
			  @user = FactoryBot.create(:super_admin_user)
			  add_jwt_header(request, @user)
			end

			it "can create and delete accesses at same time." do
				access1 =  FactoryBot.create(:access, :user_id => user1.id, :contract_id => contract.id)
				post :multi_update, params: { :contract_id=> contract.id, :update_ids => [user2.id], :delete_ids => [user1.id] }
				expect(contract.users).to eq([user2])
			end

			it "will rollback all changes when it raises errors during the transaction. " do
				access1 =  FactoryBot.create(:access, :user_id => user1.id, :contract_id => contract.id)
				post :multi_update, params: { :contract_id=> contract.id, :update_ids => [user2.id, -1 ], :delete_ids => [user1.id] }
				expect(response.status).to eq(422)
				expect(contract.users).to eq([user1])
			end

			it "can ignore duplicated records error." do
				access1 =  FactoryBot.create(:access, :user_id => user1.id, :contract_id => contract.id)
				post :multi_update, params: { :contract_id=> contract.id, :update_ids => [user2.id, user2.id ], :delete_ids => [user1.id] }
				expect(response.status).to eq(200)
				expect(contract.users).to eq([user2])
			end
		end
	end

	describe "delete" do
		context "super admin" do
			let!(:access) { FactoryBot.create(:access) }
			subject { delete :destroy, params: { :id => access.id } }

			before(:each) do
			  @user = FactoryBot.create(:super_admin_user)
			  add_jwt_header(request, @user)
			end

			it "can delete access" do
				expect {subject}.to change(Access, :count).by(-1)
				expect(response.status).to eq(204)
			end
		end
	end
end
