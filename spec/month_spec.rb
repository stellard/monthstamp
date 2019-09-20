require 'spec_helper'
require 'shared_examples'

RSpec.describe Month do

  describe "class methods" do
    subject { Month }

    describe "new" do
      context "valid month and year" do
        [
          ["1970",1],
          ["2000",12],
          [1999,"5"],
        ].each do |year, month|
          it "should have the correct values" do
            x = subject.new(month, year)
            expect(x.year).to eq year.to_i
            expect(x.month).to eq month.to_i
          end
        end
      end

      context "invald month" do
        [
          ["1970",0],
          [1999,"13"],
          [1999,"janucember"],
        ].each do |year, month|
          it "should raise error" do
            expect { subject.new(month, year) }.to raise_exception(Month::InvalidMonth)
          end
        end
      end

      context "invald year" do
        [
          ["1969",1],
          [1900,"12"],
        ].each do |year, month|
          it "should raise error" do
            expect { subject.new(month, year) }.to raise_exception(Month::InvalidYear)
          end
        end
      end

    end

    describe ".at" do
      [
        ["1970-1-1",0],
        ["1970-12-1",11],
        ["1970-2-1","1"],
        ["1971-1-1",12],
        ["1972-3-1","26"],
      ].each do |date, monthstamp|
        it "monthstamp for #{date} should be #{monthstamp}" do
          date = Date.parse(date)
          expect(subject.at(monthstamp)).to eq Month.new(date.month, date.year)
        end
      end

      it "should raise error when nil" do
        expect { subject.at(nil) }.to raise_exception
      end
    end
  end

  describe "accessors with strings" do
    let(:year) { 2000 }
    subject { Month.new(month, year) }

    before {
      subject.month = month.to_s
      subject.year = year.to_s
    }

    context "with month as integer" do
      let(:month) { 10 }
      it { expect(subject.year).to eq year }
      it { expect(subject.month).to eq month }
    end

    context "with month as name" do
      let(:month) { "october" }
      it { expect(subject.year).to eq year }
      it { expect(subject.month).to eq 10 }
    end
  end

  describe "monthstamp" do
    subject { Month }
    include_examples "monthstamp"
  end

  describe "id" do
    let(:monthstamp) { 500 }
    subject { Month.at monthstamp }
    it { expect(subject.id).to eq monthstamp }
  end

  describe "strftime" do
    subject { Month.new(2, 2013) }

    it"should work" do
      expect(subject.strftime("%B %Y")).to eq "February 2013"
    end
  end


  describe "next_year" do
    subject { Month.new(2, 2013).next_year }
    it { expect(subject.month).to eq 2 }
    it { expect(subject.year).to eq 2014 }
  end

  describe "last_year" do
    subject { Month.new(2, 2013).last_year }
    it { expect(subject.month).to eq 2 }
    it { expect(subject.year).to eq 2012 }
  end

  describe "next_month" do
    subject { Month.new(month, year).next_month }
    let(:year) { 2012 }

    context "in middle of year" do
      let(:month) { 5 }
      it { expect(subject.month).to eq 6 }
      it { expect(subject.year).to eq 2012 }
    end

    context "at end of year" do
      let(:month) { 12 }
      it { expect(subject.month).to eq 1 }
      it { expect(subject.year).to eq 2013 }
    end

  end

  describe "last_month" do
    subject { Month.new(month, year).last_month }
    let(:year) { 2012 }

    context "in middle of year" do
      let(:month) { 5 }
      it { expect(subject.month).to eq 4 }
      it { expect(subject.year).to eq 2012 }
    end

    context "at beginning of year" do
      let(:month) { 1 }
      it { expect(subject.month).to eq 12 }
      it { expect(subject.year).to eq 2011 }
    end

  end

  describe ">" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1 > month2 }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it{ is_expected.to be_truthy }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it{ is_expected.to be_falsey }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it{ is_expected.to be_falsey }
    end
  end


  describe "<" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1 < month2 }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it{ is_expected.to be_falsey }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it{ is_expected.to be_truthy }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it{ is_expected.to be_falsey }
    end
  end

  describe "<=>" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1 <=> month2 }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it { is_expected.to eq 1 }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it { is_expected.to eq -1 }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it { is_expected.to eq 0 }
    end
  end

  describe "eql?" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1.eql? month2 }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it{ is_expected.to be_falsey }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it { is_expected.to be_falsey }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it{ is_expected.to be_truthy }
    end
    context "when nil" do
      let(:month2) { nil }
      it{ is_expected.to be_falsey }
    end
  end

  describe "==" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1 == month2 }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it { is_expected.to be_falsey }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it { is_expected.to be_falsey }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it { is_expected.to be_truthy }
    end
    context "when nil" do
      let(:month2) { nil }
      it { is_expected.to be_falsey }
    end
  end

  describe "hash" do
    let(:month1) { Month.new(2, 2013) }
    subject { month1.hash == month2.hash }
    context "when less than" do
      let(:month2) { Month.new(1, 2013) }
      it { is_expected.to be_falsey }
    end
    context "when greater than" do
      let(:month2) { Month.new(3, 2013) }
      it { is_expected.to be_falsey }
    end
    context "when equal" do
      let(:month2) { Month.new(2, 2013) }
      it { is_expected.to be_truthy }
    end
  end


  describe "range" do
    subject { Month.new(3, 2013)..Month.new(5, 2013) }
    it { expect(subject.to_a).to eq (3..5).map{|d| Month.new(d, 2013) } }
  end

  describe "inspect" do
    subject { Month.new(3, 2013).inspect }
    it { is_expected.to eq "Mar 2013" }
  end


end

