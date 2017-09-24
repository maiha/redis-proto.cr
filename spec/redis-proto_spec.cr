require "./spec_helper"

module RedisProtoSpec
  struct Foo
    include Protobuf::Message

    contract_of "proto2" do
      optional :id, :string, 1
      optional :name, :string, 2
    end
  end

  FooStorage = RedisProto(Foo).new("redis://", prefix: "foo/", primary: "id")

  describe RedisProto do
    describe "#set" do
      it "serializes object and stores into redis" do
        foo = Foo.new(id: "a", name: "xyz")
        FooStorage.set(foo)
      end
    end
      
    describe "#get" do
      it "fetches from redis and deserializes message" do
        bar = FooStorage.get("a")
        bar.id.should eq("a")
        bar.name.should eq("xyz")
      end

      it "raises when the data doesn't exist" do
        expect_raises(Exception, /No data/) do
          FooStorage.get("XXX")
        end
      end
    end

    describe "#get?" do
      it "fetches from redis and deserializes message" do
        FooStorage.get?("a").should be_a(Foo)
      end

      it "raises when the data doesn't exist" do
        FooStorage.get?("XXX").should eq(nil)
      end
    end
  end
end
