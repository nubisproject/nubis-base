# Change Log

## [v1.0.1](https://github.com/nubisproject/nubis-base/tree/v1.0.1) (2015-11-20)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v1.0.0...v1.0.1)

**Implemented enhancements:**

- Puppet directory permissions are to restrictive [\#241](https://github.com/nubisproject/nubis-base/issues/241)
- Integrate proxy config in base [\#240](https://github.com/nubisproject/nubis-base/issues/240)
- Need cloudformation template for testing base builds [\#239](https://github.com/nubisproject/nubis-base/issues/239)
- \[confd\] Install cron watchdog [\#230](https://github.com/nubisproject/nubis-base/issues/230)
- \[consul\] disable ping check to google.com [\#228](https://github.com/nubisproject/nubis-base/issues/228)
- \[dnsmasq\] bind only on the loopback interface [\#205](https://github.com/nubisproject/nubis-base/issues/205)

**Fixed bugs:**

- Remove puppet module extraction [\#244](https://github.com/nubisproject/nubis-base/issues/244)
- \[mig\] New version of mig doesn't like trailing '/' in default API endpoint URL [\#242](https://github.com/nubisproject/nubis-base/issues/242)
- Make sure lsb\_release is present, looks like MiG needs it. [\#231](https://github.com/nubisproject/nubis-base/issues/231)

**Closed issues:**

- Tag  release [\#245](https://github.com/nubisproject/nubis-base/issues/245)
- \[confd\] Make sure we restart confd once Consul is configured and up and running [\#237](https://github.com/nubisproject/nubis-base/issues/237)
- \[proxy\] Need to make sure 169.254.169.254 \(ec2 metadata service\) isn't proxied [\#235](https://github.com/nubisproject/nubis-base/issues/235)
- \[fluentd\] doesn't run as root like expected on ubuntu. [\#221](https://github.com/nubisproject/nubis-base/issues/221)
- \[mig\] relay agent needs to be configurable [\#219](https://github.com/nubisproject/nubis-base/issues/219)
- Update MiG to 20150929 [\#218](https://github.com/nubisproject/nubis-base/issues/218)
- Pin fluent-plugin-ec2-metadata at a specific version [\#216](https://github.com/nubisproject/nubis-base/issues/216)
- \[fluent\] Ensure td-agent is running [\#203](https://github.com/nubisproject/nubis-base/issues/203)
- \[Amazon Linux\] Sendmail is installed [\#200](https://github.com/nubisproject/nubis-base/issues/200)
- Mig process not starting up [\#199](https://github.com/nubisproject/nubis-base/issues/199)
- Upgrade confd to v0.10.0 [\#198](https://github.com/nubisproject/nubis-base/issues/198)
- Bump nubis-puppet-eip version [\#195](https://github.com/nubisproject/nubis-base/issues/195)

**Merged pull requests:**

- Update AMI IDs file for v1.0.1 release [\#250](https://github.com/nubisproject/nubis-base/pull/250) ([tinnightcap](https://github.com/tinnightcap))
- Update StacksVersion for v1.0.1 release [\#249](https://github.com/nubisproject/nubis-base/pull/249) ([tinnightcap](https://github.com/tinnightcap))
- Make sure the default MiG API endpoint isn't '/' terminated [\#243](https://github.com/nubisproject/nubis-base/pull/243) ([gozer](https://github.com/gozer))
- Restart confd once Consul is good to go [\#238](https://github.com/nubisproject/nubis-base/pull/238) ([gozer](https://github.com/gozer))
- Add EC2 metadata service to no\_proxies list [\#236](https://github.com/nubisproject/nubis-base/pull/236) ([gozer](https://github.com/gozer))
- Ensure lsb\_release is installed \(dependency for MiG\) [\#234](https://github.com/nubisproject/nubis-base/pull/234) ([gozer](https://github.com/gozer))
- Remove simplistic node liveness health-check, it's failure prone and is useless [\#233](https://github.com/nubisproject/nubis-base/pull/233) ([gozer](https://github.com/gozer))
- Install a confd service watchdog. [\#232](https://github.com/nubisproject/nubis-base/pull/232) ([gozer](https://github.com/gozer))
- Update mig agent version and use centralized public pkg dist URL [\#229](https://github.com/nubisproject/nubis-base/pull/229) ([ameihm0912](https://github.com/ameihm0912))
- Add cloudformation for testing nubis-base builds [\#226](https://github.com/nubisproject/nubis-base/pull/226) ([tinnightcap](https://github.com/tinnightcap))
- Add proxy configuration to base [\#225](https://github.com/nubisproject/nubis-base/pull/225) ([tinnightcap](https://github.com/tinnightcap))
- Remove nubis-puppet-eip since this is used on a case by case basis [\#224](https://github.com/nubisproject/nubis-base/pull/224) ([limed](https://github.com/limed))
- Ensure td-agent runs on root on ubuntu [\#223](https://github.com/nubisproject/nubis-base/pull/223) ([gozer](https://github.com/gozer))
- Add a /config/relay\_user Consul var, to configure the mig relay user [\#222](https://github.com/nubisproject/nubis-base/pull/222) ([gozer](https://github.com/gozer))
- Upgrade mig [\#220](https://github.com/nubisproject/nubis-base/pull/220) ([gozer](https://github.com/gozer))
- Pin fluent-plugin-ec2-metadata at 0.0.7 \(latest\) [\#217](https://github.com/nubisproject/nubis-base/pull/217) ([gozer](https://github.com/gozer))
- Remove Jenkins-specific puppet modules. [\#215](https://github.com/nubisproject/nubis-base/pull/215) ([gozer](https://github.com/gozer))
- Upgrade confd to v0.10.0 [\#213](https://github.com/nubisproject/nubis-base/pull/213) ([limed](https://github.com/limed))
- Adjust puppet directory permissions [\#212](https://github.com/nubisproject/nubis-base/pull/212) ([tinnightcap](https://github.com/tinnightcap))
- Remove extracting as it is now done in bulder [\#211](https://github.com/nubisproject/nubis-base/pull/211) ([tinnightcap](https://github.com/tinnightcap))
- Cleanup some modules that are not being used [\#210](https://github.com/nubisproject/nubis-base/pull/210) ([limed](https://github.com/limed))
- There is no reason to have dnsmasq bind on anything beside loopback [\#206](https://github.com/nubisproject/nubis-base/pull/206) ([gozer](https://github.com/gozer))
- Adjust logging for RedHat variants as well as Debian [\#202](https://github.com/nubisproject/nubis-base/pull/202) ([gozer](https://github.com/gozer))
- ensure sendmail isnt installed, fixes \#200 [\#201](https://github.com/nubisproject/nubis-base/pull/201) ([gozer](https://github.com/gozer))

## [v1.0.0](https://github.com/nubisproject/nubis-base/tree/v1.0.0) (2015-08-31)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v0.9.0...v1.0.0)

**Implemented enhancements:**

- Include nubis-puppet-eip in nubis-base [\#164](https://github.com/nubisproject/nubis-base/issues/164)

**Fixed bugs:**

- \[amazon-linux\] Have dhclient.conf set dnsmasq as our preferred resolver [\#180](https://github.com/nubisproject/nubis-base/issues/180)
- \[amazon-linux\] dnsmasq isn't the default resolver [\#170](https://github.com/nubisproject/nubis-base/issues/170)
- \[amazon-linux\] Disable automatic security updates on boot [\#153](https://github.com/nubisproject/nubis-base/issues/153)
- Consul bootstrap uses a jq 1.4 feature, not available  yet. [\#187](https://github.com/nubisproject/nubis-base/issues/187)

**Closed issues:**

- Consul retry\_join can't contain port numbers [\#178](https://github.com/nubisproject/nubis-base/issues/178)
- \[consul\] use /v1/status/peers to auto join nodes from the UI instead of relying [\#175](https://github.com/nubisproject/nubis-base/issues/175)
- \[amazon-linux\] dnsmasq isn't configured to forward to the DHCP provided nameserver [\#171](https://github.com/nubisproject/nubis-base/issues/171)
- Consul not starting up [\#168](https://github.com/nubisproject/nubis-base/issues/168)
- Include CPAN puppet module [\#161](https://github.com/nubisproject/nubis-base/issues/161)
- consul-template broken [\#159](https://github.com/nubisproject/nubis-base/issues/159)
- consul-do is not executable [\#157](https://github.com/nubisproject/nubis-base/issues/157)
- Install consulate on base images [\#150](https://github.com/nubisproject/nubis-base/issues/150)
- The DNS portion to discover Consul is hard-coded. [\#143](https://github.com/nubisproject/nubis-base/issues/143)
- Install credstash on base images [\#152](https://github.com/nubisproject/nubis-base/issues/152)
- Tag v1.0.0 release [\#148](https://github.com/nubisproject/nubis-base/issues/148)
- \[puppet\] Update outdated modules [\#138](https://github.com/nubisproject/nubis-base/issues/138)

**Merged pull requests:**

- PR for v1.0.0 release [\#191](https://github.com/nubisproject/nubis-base/pull/191) ([gozer](https://github.com/gozer))
- Use perl to remove the port number from hosts, as jq's split\(\) is off limits for now [\#189](https://github.com/nubisproject/nubis-base/pull/189) ([gozer](https://github.com/gozer))
- Turn the Consul bootstrap script into something that's a lot more resilient to failures of all kinds. [\#186](https://github.com/nubisproject/nubis-base/pull/186) ([gozer](https://github.com/gozer))
- Prepend nameserver 127.0.0.1 if amazon linux [\#185](https://github.com/nubisproject/nubis-base/pull/185) ([limed](https://github.com/limed))
- Consul: Datacenter must be alpha-numeric with underscores and hypens only [\#184](https://github.com/nubisproject/nubis-base/pull/184) ([gozer](https://github.com/gozer))
- Add support for a new user-data variable, NUBIS\_ACOUNT. [\#183](https://github.com/nubisproject/nubis-base/pull/183) ([gozer](https://github.com/gozer))
- Plumbing to get nubis-lib included in base image [\#182](https://github.com/nubisproject/nubis-base/pull/182) ([limed](https://github.com/limed))
- Remove port numbers from peers, as retry\_join doesn't like it [\#179](https://github.com/nubisproject/nubis-base/pull/179) ([gozer](https://github.com/gozer))
- Use the Consul UI to discover peers first, then fallback on our DNS join endpoint [\#177](https://github.com/nubisproject/nubis-base/pull/177) ([gozer](https://github.com/gozer))
- Install consulate in base images [\#174](https://github.com/nubisproject/nubis-base/pull/174) ([limed](https://github.com/limed))
- \[do-not-merge\] \[review-request\] Nubis bash library [\#173](https://github.com/nubisproject/nubis-base/pull/173) ([limed](https://github.com/limed))
- Extra comma causes consul to not startup [\#169](https://github.com/nubisproject/nubis-base/pull/169) ([limed](https://github.com/limed))
- Missing comma [\#166](https://github.com/nubisproject/nubis-base/pull/166) ([limed](https://github.com/limed))
- Add nubis-puppet-eip module to Puppetfile [\#165](https://github.com/nubisproject/nubis-base/pull/165) ([limed](https://github.com/limed))
- Include meltwater/cpan 1.0.1 [\#162](https://github.com/nubisproject/nubis-base/pull/162) ([gozer](https://github.com/gozer))
- Fix incorrect references to consul-template 0.7.0. Fixes \#159 [\#160](https://github.com/nubisproject/nubis-base/pull/160) ([gozer](https://github.com/gozer))
- consul-do permission fix [\#158](https://github.com/nubisproject/nubis-base/pull/158) ([limed](https://github.com/limed))
- Include credstash in the base images [\#156](https://github.com/nubisproject/nubis-base/pull/156) ([gozer](https://github.com/gozer))
- Disable Amazon Linux auto-updating in our base images, and make sure it stays disabled in derived images. [\#155](https://github.com/nubisproject/nubis-base/pull/155) ([gozer](https://github.com/gozer))
- Upgrade modules from \#138 [\#151](https://github.com/nubisproject/nubis-base/pull/151) ([gozer](https://github.com/gozer))
- Don't break with SSL RSA keys \(as generated on a Mac\) [\#149](https://github.com/nubisproject/nubis-base/pull/149) ([gozer](https://github.com/gozer))
- Add support for CONSUL\_ACL\_TOKEN in bootstrap. [\#146](https://github.com/nubisproject/nubis-base/pull/146) ([gozer](https://github.com/gozer))
- When we detect we are a Consul server, use NUBIS\_PROJECT to build the DNS discovery name, don't hard-code .consul. Fixes \#143 [\#144](https://github.com/nubisproject/nubis-base/pull/144) ([gozer](https://github.com/gozer))
- Add support for 3 more Consul Server bootstrap options: [\#142](https://github.com/nubisproject/nubis-base/pull/142) ([gozer](https://github.com/gozer))

## [v0.9.0](https://github.com/nubisproject/nubis-base/tree/v0.9.0) (2015-07-23)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v0.1...v0.9.0)

**Closed issues:**

- Move the creation of /etc/puppet/nubis/{files,templates} to the base image [\#134](https://github.com/nubisproject/nubis-base/issues/134)
- Add auditd, and other opsec required components to base [\#63](https://github.com/nubisproject/nubis-base/issues/63)

**Merged pull requests:**

- Updating changelog for v0.9.0 release [\#141](https://github.com/nubisproject/nubis-base/pull/141) ([gozer](https://github.com/gozer))
- adding openldap module to Puppetfile [\#137](https://github.com/nubisproject/nubis-base/pull/137) ([jdow](https://github.com/jdow))
- fix ordering issue [\#136](https://github.com/nubisproject/nubis-base/pull/136) ([gozer](https://github.com/gozer))
- Move creation of /etc/puppet/nubis/{files,templates} to base image. Fixes \#134 [\#135](https://github.com/nubisproject/nubis-base/pull/135) ([gozer](https://github.com/gozer))
- Ubuntu repositories have very old versions of the ec2-ami-tools that just don't work at all. [\#130](https://github.com/nubisproject/nubis-base/pull/130) ([gozer](https://github.com/gozer))

## [v0.1](https://github.com/nubisproject/nubis-base/tree/v0.1) (2015-06-11)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v0.79...v0.1)

## [v0.79](https://github.com/nubisproject/nubis-base/tree/v0.79) (2015-06-11)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v1.35...v0.79)

**Closed issues:**

- Upgrade to consul-template 0.10.0 [\#125](https://github.com/nubisproject/nubis-base/issues/125)
- Replace ec2metadata usage with good old curl [\#113](https://github.com/nubisproject/nubis-base/issues/113)
- gozer-confd only installs an upstart script, needs fixing for RedHats [\#112](https://github.com/nubisproject/nubis-base/issues/112)
- Amazon Linux AMIs need the ec2metadata tool present. [\#111](https://github.com/nubisproject/nubis-base/issues/111)
- Need to integrate consul-do in the base image [\#10](https://github.com/nubisproject/nubis-base/issues/10)

**Merged pull requests:**

- Upgrade consul-template to 0.10.0, fixes \#125 [\#128](https://github.com/nubisproject/nubis-base/pull/128) ([gozer](https://github.com/gozer))
- add mkrakowitzer/confluence [\#124](https://github.com/nubisproject/nubis-base/pull/124) ([gozer](https://github.com/gozer))
- make sure /etc/rc.local is root owned [\#120](https://github.com/nubisproject/nubis-base/pull/120) ([gozer](https://github.com/gozer))
- Switch to official puppet repos for our own puppet modules. [\#119](https://github.com/nubisproject/nubis-base/pull/119) ([gozer](https://github.com/gozer))
- include consul-do, closes \#10 [\#117](https://github.com/nubisproject/nubis-base/pull/117) ([gozer](https://github.com/gozer))

## [v1.35](https://github.com/nubisproject/nubis-base/tree/v1.35) (2015-06-04)
[Full Changelog](https://github.com/nubisproject/nubis-base/compare/v0.165...v1.35)

**Fixed bugs:**

- Amazon linux doesn't work [\#84](https://github.com/nubisproject/nubis-base/issues/84)

**Closed issues:**

- Upgrade confd to 0.9.0 [\#100](https://github.com/nubisproject/nubis-base/issues/100)
- Disable the creation of /etc/nubis-release [\#81](https://github.com/nubisproject/nubis-base/issues/81)
- Need to integrate envconsul in the base image [\#66](https://github.com/nubisproject/nubis-base/issues/66)
- Move our nubis-puppet stuff to /etc/puppet/modules so they are in a default [\#65](https://github.com/nubisproject/nubis-base/issues/65)
- Make AMIs public by default once we are happy with our state [\#53](https://github.com/nubisproject/nubis-base/issues/53)
- Build vagrant images for local development in addition to deployable AMIs [\#39](https://github.com/nubisproject/nubis-base/issues/39)
- We need a tool to drive packer and publish AMIs \(and possibly other outputs\) into Consul [\#32](https://github.com/nubisproject/nubis-base/issues/32)
- Need to integrate consul-template in the base images [\#11](https://github.com/nubisproject/nubis-base/issues/11)

**Merged pull requests:**

- Add ElasticSearch [\#108](https://github.com/nubisproject/nubis-base/pull/108) ([gozer](https://github.com/gozer))
- Upgrade puppet modules: \(fixes nubisproject/nubis-puppet \#41\) [\#106](https://github.com/nubisproject/nubis-base/pull/106) ([gozer](https://github.com/gozer))
- upgrade confd to 0.9.0 for issue \#100 [\#104](https://github.com/nubisproject/nubis-base/pull/104) ([gozer](https://github.com/gozer))
- Just to be tidy, perform a full Consul nuke and restart after bootstraping it [\#96](https://github.com/nubisproject/nubis-base/pull/96) ([gozer](https://github.com/gozer))
- Addressing https://github.com/Nubisproject/nubis-base/issues/81 [\#93](https://github.com/nubisproject/nubis-base/pull/93) ([bhourigan](https://github.com/bhourigan))
- include gcc [\#90](https://github.com/nubisproject/nubis-base/pull/90) ([gozer](https://github.com/gozer))
- Fix ruby-dev name picking on Debian vs RH distros [\#89](https://github.com/nubisproject/nubis-base/pull/89) ([gozer](https://github.com/gozer))
- Solving issue 84 [\#88](https://github.com/nubisproject/nubis-base/pull/88) ([bhourigan](https://github.com/bhourigan))
- add ec2-metadata to forwarded logs [\#87](https://github.com/nubisproject/nubis-base/pull/87) ([gozer](https://github.com/gozer))
- add missing dependency for the EC2 fluentd plugin [\#86](https://github.com/nubisproject/nubis-base/pull/86) ([gozer](https://github.com/gozer))
- All forwarded fluentd logs need to start with forward. [\#85](https://github.com/nubisproject/nubis-base/pull/85) ([gozer](https://github.com/gozer))
- one more debgging bit [\#83](https://github.com/nubisproject/nubis-base/pull/83) ([gozer](https://github.com/gozer))
- more verbose startup [\#82](https://github.com/nubisproject/nubis-base/pull/82) ([gozer](https://github.com/gozer))
- Revert "Revert "disable amazon-instance-ubuntu for now, ec2-upload-bundle is borked with IAM roles"" [\#80](https://github.com/nubisproject/nubis-base/pull/80) ([gozer](https://github.com/gozer))
- Datadog integration with Consul [\#79](https://github.com/nubisproject/nubis-base/pull/79) ([gozer](https://github.com/gozer))
- Revert "disable amazon-instance-ubuntu for now, ec2-upload-bundle is bor... [\#78](https://github.com/nubisproject/nubis-base/pull/78) ([bhourigan](https://github.com/bhourigan))
- disable amazon-instance-ubuntu for now, ec2-upload-bundle is borked with IAM roles [\#77](https://github.com/nubisproject/nubis-base/pull/77) ([gozer](https://github.com/gozer))
- After battling the real issue behind the dnsmasq race-conditon, finally fixed it. [\#76](https://github.com/nubisproject/nubis-base/pull/76) ([gozer](https://github.com/gozer))
- Initial stub install of the datadog agent, still missing the secret bits [\#75](https://github.com/nubisproject/nubis-base/pull/75) ([gozer](https://github.com/gozer))
- Make Consul more aggressive about trying to join the cluster [\#74](https://github.com/nubisproject/nubis-base/pull/74) ([gozer](https://github.com/gozer))
- fix shell munging of user-data [\#73](https://github.com/nubisproject/nubis-base/pull/73) ([gozer](https://github.com/gozer))
- Update to Consul 0.5.0 with support for TLS [\#72](https://github.com/nubisproject/nubis-base/pull/72) ([gozer](https://github.com/gozer))
- bump [\#70](https://github.com/nubisproject/nubis-base/pull/70) ([gozer](https://github.com/gozer))
- Fix typo in JSON [\#69](https://github.com/nubisproject/nubis-base/pull/69) ([gozer](https://github.com/gozer))
- Addressing https://github.com/Nubisproject/nubis-base/issues/65 [\#68](https://github.com/nubisproject/nubis-base/pull/68) ([bhourigan](https://github.com/bhourigan))
- add support for Consul bootstrap via user-data [\#64](https://github.com/nubisproject/nubis-base/pull/64) ([gozer](https://github.com/gozer))
- use nubis::discovery::check as a basic liveness check [\#61](https://github.com/nubisproject/nubis-base/pull/61) ([gozer](https://github.com/gozer))
- Add a simple consul node liveness check, a ping for google.com \(temoprary\) [\#60](https://github.com/nubisproject/nubis-base/pull/60) ([gozer](https://github.com/gozer))
- Changing nubis/packer to nubis/builder, and fixing instance-store builds [\#59](https://github.com/nubisproject/nubis-base/pull/59) ([bhourigan](https://github.com/bhourigan))
- updated to 2.26 [\#58](https://github.com/nubisproject/nubis-base/pull/58) ([gozer](https://github.com/gozer))
- fix ordering issue [\#57](https://github.com/nubisproject/nubis-base/pull/57) ([gozer](https://github.com/gozer))
- puppet-lint [\#56](https://github.com/nubisproject/nubis-base/pull/56) ([gozer](https://github.com/gozer))
- Nubis builder converstion [\#55](https://github.com/nubisproject/nubis-base/pull/55) ([bhourigan](https://github.com/bhourigan))
- Fixing a bug in AMI namespace collision [\#54](https://github.com/nubisproject/nubis-base/pull/54) ([bhourigan](https://github.com/bhourigan))
- Incorporating improvements as discussed earlier today [\#52](https://github.com/nubisproject/nubis-base/pull/52) ([bhourigan](https://github.com/bhourigan))
- Numerous bug fixes [\#51](https://github.com/nubisproject/nubis-base/pull/51) ([bhourigan](https://github.com/bhourigan))
- Added automatic base AMI discovery, changed make target names, augmented README.md [\#50](https://github.com/nubisproject/nubis-base/pull/50) ([bhourigan](https://github.com/bhourigan))

## [v0.165](https://github.com/nubisproject/nubis-base/tree/v0.165) (2015-02-16)
**Closed issues:**

- Create an /etc/nubis-release file in the base images for release identification [\#45](https://github.com/nubisproject/nubis-base/issues/45)
- let's be consistent and install librarian-puppet in the base image [\#35](https://github.com/nubisproject/nubis-base/issues/35)
- Need to look into building a base image from Amazon Linux AMIs as well as Ubuntu. [\#27](https://github.com/nubisproject/nubis-base/issues/27)
- Integrate jq in the base image [\#14](https://github.com/nubisproject/nubis-base/issues/14)
- Need to integrate a log forwarder in the base image [\#12](https://github.com/nubisproject/nubis-base/issues/12)
- Need to get a provisionner working with amazon-instance [\#9](https://github.com/nubisproject/nubis-base/issues/9)
- Need to cleanly solve the MTA issue in the base image \(sendmail is not great\) [\#3](https://github.com/nubisproject/nubis-base/issues/3)
- Need to integrate confd in the base image [\#2](https://github.com/nubisproject/nubis-base/issues/2)
- Need to integrate consul agent in the base images [\#1](https://github.com/nubisproject/nubis-base/issues/1)

**Merged pull requests:**

- Built Nubis Base 0.165 [\#48](https://github.com/nubisproject/nubis-base/pull/48) ([gozer](https://github.com/gozer))
- Tyop fix [\#47](https://github.com/nubisproject/nubis-base/pull/47) ([gozer](https://github.com/gozer))
- Add a /etc/nubis-release file to images. Fixes issue \#45 [\#46](https://github.com/nubisproject/nubis-base/pull/46) ([gozer](https://github.com/gozer))
- Made 0.163 AMIs [\#44](https://github.com/nubisproject/nubis-base/pull/44) ([gozer](https://github.com/gozer))
- Instead of dropping a code specific /etc/rc.local, use run-parts to execute [\#43](https://github.com/nubisproject/nubis-base/pull/43) ([gozer](https://github.com/gozer))
- Docs [\#42](https://github.com/nubisproject/nubis-base/pull/42) ([gozer](https://github.com/gozer))
- Fixed bug in puppet package pinning and added -dist file for variables.json [\#41](https://github.com/nubisproject/nubis-base/pull/41) ([bhourigan](https://github.com/bhourigan))
- Bumping release, and changed AMI id for amazon instance store builder [\#37](https://github.com/nubisproject/nubis-base/pull/37) ([bhourigan](https://github.com/bhourigan))
- Updating AMI ID to Ubuntu utopic 14.10, released 20141204 [\#34](https://github.com/nubisproject/nubis-base/pull/34) ([bhourigan](https://github.com/bhourigan))
- switch to release.build in versionning [\#33](https://github.com/nubisproject/nubis-base/pull/33) ([gozer](https://github.com/gozer))
- Install jq, a cool JSON cli query tool in the base image. [\#30](https://github.com/nubisproject/nubis-base/pull/30) ([gozer](https://github.com/gozer))
- Silence the tar job a little [\#29](https://github.com/nubisproject/nubis-base/pull/29) ([gozer](https://github.com/gozer))
- bump version [\#26](https://github.com/nubisproject/nubis-base/pull/26) ([gozer](https://github.com/gozer))
- Just some cleaning ups [\#25](https://github.com/nubisproject/nubis-base/pull/25) ([gozer](https://github.com/gozer))
- Finish up confd integration. [\#24](https://github.com/nubisproject/nubis-base/pull/24) ([gozer](https://github.com/gozer))
- move terraform semples under nubis/ [\#23](https://github.com/nubisproject/nubis-base/pull/23) ([gozer](https://github.com/gozer))
- move base puppet manifests in tree [\#22](https://github.com/nubisproject/nubis-base/pull/22) ([gozer](https://github.com/gozer))
- use instance-id for node name [\#21](https://github.com/nubisproject/nubis-base/pull/21) ([gozer](https://github.com/gozer))
- Documenting release.sh [\#20](https://github.com/nubisproject/nubis-base/pull/20) ([bhourigan](https://github.com/bhourigan))
- add a simple terraform template to just launch one base image with consul lookups [\#19](https://github.com/nubisproject/nubis-base/pull/19) ([gozer](https://github.com/gozer))
- Add consul auto-discovery in packer template. Needs to move into puppet eventually [\#18](https://github.com/nubisproject/nubis-base/pull/18) ([gozer](https://github.com/gozer))
- Convert base to use puppet-librarian itself too to pull in nubis-puppet [\#17](https://github.com/nubisproject/nubis-base/pull/17) ([gozer](https://github.com/gozer))
- Adding back manifest\_file until patch is accepted upstream [\#16](https://github.com/nubisproject/nubis-base/pull/16) ([bhourigan](https://github.com/bhourigan))
- add support for IAM instance profiles [\#15](https://github.com/nubisproject/nubis-base/pull/15) ([gozer](https://github.com/gozer))
- see commits [\#13](https://github.com/nubisproject/nubis-base/pull/13) ([bhourigan](https://github.com/bhourigan))
- Adding MPL2 License [\#8](https://github.com/nubisproject/nubis-base/pull/8) ([tinnightcap](https://github.com/tinnightcap))
- Initial commit of updated main.json and bootstrap script which installs ... [\#7](https://github.com/nubisproject/nubis-base/pull/7) ([bhourigan](https://github.com/bhourigan))
- add bare-bones registry [\#6](https://github.com/nubisproject/nubis-base/pull/6) ([gozer](https://github.com/gozer))
- cleanup and doc [\#5](https://github.com/nubisproject/nubis-base/pull/5) ([gozer](https://github.com/gozer))
- Base import [\#4](https://github.com/nubisproject/nubis-base/pull/4) ([gozer](https://github.com/gozer))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*