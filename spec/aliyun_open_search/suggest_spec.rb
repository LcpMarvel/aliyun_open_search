require "spec_helper"

describe AliyunOpenSearch::Suggest do
  let(:params) do
    {
      query: "搜",
      suggest_name: "test_suggest",
      hit: 5
    }
  end

  let(:index_name) { "test" }

  context "AliyunOpenSearch::Suggest.new(app_name).execute(params)" do
    it "send request directly" do
      res = AliyunOpenSearch::Suggest.new(index_name).execute(params)

      expect(JSON.load(res)["status"]).to eq "OK"
    end
  end
end
