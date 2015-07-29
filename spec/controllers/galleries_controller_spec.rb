require 'rails_helper'

RSpec.describe GalleriesController, type: :controller do
  context "user is signed in" do
    let(:test_user) { create(:user) }

    before do
      allow(controller).to receive(:current_user).and_return(test_user)
      allow(controller).to receive(:authenticate_user!).and_return(test_user)
    end

    describe "POST #create" do

      subject { post :create, params }

      context "with valid params" do

        let(:params) do
          {
            gallery: { title: "MyTitle", user: test_user, description: "MyDesc",
                images_attributes: [{ title: "ImgTitle",
                                      description: "ImgDescription",
                                      user: test_user,
                                      picture_file_name: 'test-image.jpg' }] }
          }
        end

        it "creates a new Gallery" do
          expect{ subject }.to change{ Gallery.count }.by(1)
        end

        it "creates some new Images" do
          expect{ subject }.to change(Image, :count).by(1)
        end

        it "redirects to the created Gallery page" do
          subject
          expect(response).to redirect_to(gallery_path(Gallery.last))
        end

        it "exposes the created Gallery" do
          subject
          expect(controller.gallery).to be_a(Gallery)
          expect(controller.gallery).to be_persisted
        end
      end
    end
  end

  context "user is not signed in" do

    before do
      allow(controller).to receive(:user_signed_in?).and_return(false)
      allow(controller).to receive(:current_user).and_return(nil)
    end

    describe "POST #create" do

      subject { post :create, params }

      context "with valid params" do

        let(:params) do
          {
            gallery: { title: "MyTitle", description: "MyDesc",
                images_attributes: [{ title: "ImgTitle",
                                      description: "ImgDescription",
                                      picture_file_name: 'test-image.jpg' }] }
          }
        end

        it "redirects to the login page" do
          subject
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "with invalid params" do

        let(:params) do
          {
            gallery: { title: "", description: "",
                images_attributes: [{ title: "",
                                      description: "",
                                      picture_file_name: '' }] }
          }
        end

        it "redirects to the login page" do
          subject
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
end