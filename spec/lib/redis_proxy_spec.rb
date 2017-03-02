require 'spec_helper'

module AirbrakeProxy
  describe RedisProxy do

    subject { RedisProxy }

    describe 'keys' do
      let(:keys) { [:keys] }

      it 'forwards its calls to Redis' do
        expect(redis).to receive(:keys).and_return keys
        expect(subject.keys).to eql(keys)
      end

      context 'Redis::TimeoutError' do
        it 'should retry 3 times the call to redis' do
          expect(redis).to receive(:keys).exactly(10).times.and_raise(::Redis::TimeoutError)
          expect { subject.keys }.to raise_error(::Redis::TimeoutError)
        end
      end
    end

    private

    def redis
      @redis ||= AirbrakeProxy.configuration.redis
    end
  end
end
