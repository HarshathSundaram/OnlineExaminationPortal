require 'rails_helper'

RSpec.describe TestHistory, type: :model do
  describe "associations" do
    
    context "belongs_to" do
      let!(:test) {build(:test)}
      let!(:test_history) {build(:test_history,test:test)}
      it "test is true" do
        expect(test_history.test).to be_an_instance_of(Test)
      end
    end

    context "belongs_to" do
      let(:student) {create(:student)}
      let(:test_history) {build(:test_history,student:student)}
      it "student is true" do
        expect(test_history.student).to be_an_instance_of(Student)
      end
    end
  
  end

  describe "mark_scored" do
    before(:each) do
      test_history.validate
    end
    
    context "when mark scored is not present" do
      let(:test_history) {build(:test_history,mark_scored:nil)}
      it "throws an error" do
        expect(test_history.errors).to include(:mark_scored)
      end
    end

    context "when mark scored is empty" do
      let(:test_history) {build(:test_history,mark_scored:"")}
      it "throws an error" do
        expect(test_history.errors).to include(:mark_scored)
      end
    end

     context "when mark scored is string" do
      let(:test_history) {build(:test_history,mark_scored:"AB")}
      it "throws an error" do
        expect(test_history.errors).to include(:mark_scored)
      end
    end

     context "when mark scored is present" do
      let(:test_history) {build(:test_history,mark_scored:10)}
      it "doesn't throws any error" do
        expect(test_history.errors).to_not include(:mark_scored)
      end
    end

  end


  describe "total_mark" do
    before(:each) do
      test_history.validate
    end
    
    context "when total mark is not present" do
      let(:test_history) {build(:test_history,total_mark:nil)}
      it "throws an error" do
        expect(test_history.errors).to include(:total_mark)
      end
    end

    context "when total mark is empty" do
      let(:test_history) {build(:test_history,total_mark:"")}
      it "throws an error" do
        expect(test_history.errors).to include(:total_mark)
      end
    end

     context "when total mark is string" do
      let(:test_history) {build(:test_history,total_mark:"AB")}
      it "throws an error" do
        expect(test_history.errors).to include(:total_mark)
      end
    end

     context "when total mark is present" do
      let(:test_history) {build(:test_history,total_mark:10)}
      it "doesn't throws any error" do
        expect(test_history.errors).to_not include(:total_mark)
      end
    end

  end
end
