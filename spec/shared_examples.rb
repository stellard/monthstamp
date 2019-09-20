require 'spec_helper'

RSpec.shared_examples_for "monthstamp" do
  [
    ["1970-1-1",0],
    ["1970-12-1",11],
    ["1970-2-1",1],
    ["1971-1-1",12],
    ["1972-3-1",26],
  ].each do |date, monthstamp|
    it "monthstamp for #{date} should be #{monthstamp}" do
      expect(subject.parse(date).monthstamp).to eq monthstamp
    end
    it { expect(subject.parse(date).to_month).to eq Month.at(monthstamp) }
  end
end
