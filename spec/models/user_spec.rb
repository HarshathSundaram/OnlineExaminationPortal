require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do

    context "belongs_to" do
      let!(:user) {create(:user, :for_student)}
      it "student is true" do
        expect(user.userable).to be_an_instance_of(Student)
      end
    end
    context "belongs_to" do
      let!(:user) {create(:user, :for_instructor)}
      it "instructor is true" do
        expect(user.userable).to be_an_instance_of(Instructor)
      end
    end
  end


  describe "name" do
    before(:each) do
      user.validate
    end

    context "when name is empty" do
      let!(:user) {build(:user, name:"")}
      it "throws an error" do
        expect(user.errors).to include(:name)
      end
    end

    context "when name is not present" do
      let!(:user) {build(:user, name:nil)}
      it "throws an error" do
        expect(user.errors).to include(:name)
      end
    end

    context "when name length is less than 4" do
      let!(:user) {build(:user, name:"Anu")}
      it "throws an error" do
        expect(user.errors).to include(:name)
      end  
    end

    context "when name length is greater than 20" do
      let!(:user) {build(:user, name:"Kamado Tanjiro Nezuko")}
      it "throws an error" do
        expect(user.errors).to include(:name)
      end 
    end

    context "when name is present" do
      let!(:user) {build(:user, name: "Naren")}
      it "doesn't throw any error" do
        expect(user.errors).to_not include(:name)
      end
    end
  end

  describe "email" do

    before(:each) do
      user.validate
    end


    context "when email is present" do
      let(:user) {build(:user,email:"narendranath2445@gmail.com")}
      it "doesn't throw any error" do
        expect(user.errors).to_not include(:email)
      end
    end

    context "when email is not present" do
      let(:user) {build(:user,email:nil)}
      it "throws an error" do
        expect(user.errors).to include(:email)
      end
    end

    context "when email is empty" do
      let(:user) {build(:user,email:"")}
      it "throws an error" do
        expect(user.errors).to include(:email)
      end
    end

    context "when it is not an email" do
      let(:user) {build(:user,email:"naren")}
      it "throws an error" do
        expect(user.errors).to include(:email)
      end
    end

  end

  describe "password" do

    before(:each) do
      user.validate
    end

    context  "when password is present" do
      let(:user) {build(:user,password:"Naren@123")}
      it "doesn't throw any error" do
        expect(user.errors).to_not include(:password)
      end
    end

    context "when password is not present" do
      let(:user) {build(:user, password:nil)}
      it "throws an error" do
        expect(user.errors).to include(:password)
      end
    end

    context "when password is empty" do
      let(:user) {build(:user,password:"")}
      it "throws an error" do
        expect(user.errors).to include(:password)
      end
    end

    context "when password length is less than 6" do
      let(:user) {build(:user,password:"an@4")}
      it "throws an error" do
        expect(user.errors).to include(:password)
      end
    end

  end

  describe "confirm password" do

    before(:each) do
      user.validate
    end

    context "when confirm password is not present" do
      let(:user) {build(:user,password_confirmation:" ")}
      it "throws an error" do
        expect(user.errors).to include(:password_confirmation)
      end
    end

    context "when confirm pasword doesn't match password" do
      let(:user) {build(:user,password:"1234567",password_confirmation:"7654321")}
      it "throws an error" do
        expect(user.errors).to include(:password_confirmation)
      end
    end

    context "when confirm pasword matches password" do
      let(:user) {build(:user,password:"1234567",password_confirmation:"1234567")}
      it "doesn't throws any error" do
        expect(user.errors).to_not include(:password_confirmation)
      end
    end
  end

  describe "gender" do
    before(:each) do
      user.validate
    end

    context "when gender is not present" do
      let(:user) {build(:user,gender:nil)}
      it "throws an error" do
        expect(user.errors).to include(:gender)
      end
    end

    context "when gender is empty" do
      let(:user) {build(:user, gender:"")}
      it "throws an error" do
        expect(user.errors).to include(:gender)
      end
    end

    context "when gender is present" do
      let(:user) {build(:user, gender:"Male")}
      it "doesn't throws any error" do
        expect(user.errors).to_not include(:gender)
      end
    end

  end

end
