require 'spec_helper'

describe 'prometheus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'Create the config file' do
        context 'by default, using the template' do
          it do
            is_expected.to contain_file('prometheus.yaml').
              with(content: %r{---})
          end
        end
        context 'when param congi_type is template' do
          let(:params) { { 'config_type' => 'template' } }
          it do
            is_expected.to contain_file('prometheus.yaml').
              with(content: %r{---})
          end
        end
        context 'when parameter config_type is source and and config_source is supplied' do
          let(:thesource) { File.expand_path(File.dirname(__FILE__) + '/../fixtures/files/prometheus.yaml') }
          let(:params) { { 'config_type' => 'source', 'config_source' => thesource } }
          it do
            is_expected.to contain_file('prometheus.yaml').
              with(source: thesource)
          end
        end
        context 'with an invalid config_type' do
          let(:params) { { 'config_type' => 'invalid' } }
          it do
            expect { catalogue }.to raise_error(Puppet::Error, %r{is not supported by this module})
          end
        end
      end
    end
  end
end
