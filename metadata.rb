name 'princexml'

maintainer 'OptimisCorp., Inc.'
maintainer_email 'ops+cookbooks@optimiscorp.com'

license 'Apache 2.0'

description 'Downgrade PrinceXML from 8.0 and Install 7.1'

version '0.0.1'

recipe 'princexml::purge', 'Purges PrinceXML 8.0'
recipe 'princexml::default', 'Installs PrinceXML 7.1'

supports 'ubuntu'
