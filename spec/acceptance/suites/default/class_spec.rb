require 'spec_helper_acceptance'

test_name 'haveged'

describe 'haveged' do
  let(:manifest) {
    <<-EOS
      include '::haveged'
    EOS
  }

  hosts.each do |host|
    context "on a stable host" do
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        apply_manifest_on(host, manifest, :catch_failures => true)
      end

      it 'should be installed' do
        on(host, 'puppet resource package haveged') do
          expect(stdout).to_not match(/ensure => 'absent'/)
        end
      end

      it 'should be running' do
        on(host, 'puppet resource service haveged') do
          expect(stdout).to match(/ensure => 'running'/)
          expect(stdout).to match(/enable => 'true'/)
        end
      end

      it 'should be idempotent' do
        apply_manifest_on(host, manifest, :catch_changes => true)
      end

      it 'should uninstall with no errors' do
        hieradata = <<-EOS
          'haveged::package_ensure' : 'absent'
        EOS

        set_hieradata_on(host, hieradata)
        apply_manifest_on(host, manifest, :catch_failures => true)
      end

      it 'should not be installed' do
        on(host, 'puppet resource package haveged') do
          expect(stdout).to match(/ensure => 'absent'/)
        end
      end

      it 'should not be running' do
        on(host, 'puppet resource service haveged') do
          expect(stdout).to match(/ensure => 'stopped'/)
          expect(stdout).to match(/enable => 'false'/)
        end
      end

      it 'should be idempotent after uninstall' do
        apply_manifest_on(host, manifest, :catch_changes => true)
      end
    end
  end
end
