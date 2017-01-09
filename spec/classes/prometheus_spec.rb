require 'spec_helper'

describe 'prometheus' do
  on_supported_os.each do |os, facts|
    context "with defaults on #{os}" do
      let(:facts) do
        facts.merge( { puppetmaster => 'localhost.localdomain' } )
      end
      let :params do
        { config => { 'hash' => 10 } }
      end
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('prometheus') }
      it { is_expected.to contain_class('prometheus::config') }
      it { is_expected.to contain_class('prometheus::install') }
      it { is_expected.to contain_class('prometheus::run_service') }
    end
  end
end
