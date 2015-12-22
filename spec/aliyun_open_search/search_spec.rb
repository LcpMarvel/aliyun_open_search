require "spec_helper"

describe AliyunOpenSearch::Search do
  let(:params) do
    {
      query: "query=default:\'搜索\'"
    }
  end

  let(:index_name) { "test" }

  context "AliyunOpenSearch::Search.new(app_name).execute(params)" do
    it "send request directly" do
      res = AliyunOpenSearch::Search.new(index_name).execute(params)

      expect(JSON.load(res)["status"]).to eq "OK"
    end
  end
end
