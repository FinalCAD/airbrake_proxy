require 'spec_helper'

describe AirbrakeProxy do
  let(:exception) {  Exception.new('my-exception') }
  let(:params)    {{ env: :test }}

  before(:each) { AirbrakeProxy.clean! }

  subject { AirbrakeProxy.notify(exception, params) }

  it 'should increment exception' do
    expect(Airbrake).to receive(:notify).with(exception, params)
    expect { subject }.to change {
      RedisProxy.get('AIRBRAKE::my-exception')
    }.from(nil).to('1')
    expect(AirbrakeProxy.keys).to be_include(['AIRBRAKE::my-exception', '1'])
    expect {
      AirbrakeProxy.remove('AIRBRAKE::my-exception')
    }.to change {
      AirbrakeProxy.keys
    }.from([['AIRBRAKE::my-exception', '1']]).to([])
    expect(AirbrakeProxy.remove('AIRBRAKE::my-exception')).to be_falsey
  end

  it 'should not notify airbrake' do
    expect(Airbrake).to_not receive(:notify)
    expect(AirbrakeProxy).to receive(:authorized_to_notify?)
      .with('AIRBRAKE::my-exception') { false }
    expect(AirbrakeProxy.configuration.logger).to receive(:info).with('AirbrakeProxy => AIRBRAKE::my-exception was notified too many times')

    subject
  end

  context 'without exception' do
    let(:exception) { nil }

    it 'should not notify airbrake' do
      expect(Airbrake).to_not receive(:notify)

      subject
    end
  end

  context 'with other type of exception' do
    let(:exception) { OpenStruct.new(foo: 'bar') }

    it 'should notify airbrake' do
      expect { subject }.to change {
        RedisProxy.get('AIRBRAKE::openstruct-foo-bar')
      }.from(nil).to('1')

      subject
    end
  end
end
