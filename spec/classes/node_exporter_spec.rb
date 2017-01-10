require 'spec_helper'

describe 'prometheus::node_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          staging_http_get: 'curl'
        )
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.13.0',
            arch: 'amd64',
            os: 'linux'
          }
        end
        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/node_exporter').with('target' => '/opt/staging/node_exporter-0.13.0.linux-amd64/node_exporter') }
        end
      end
    end
  end
end
