use v6;

unit module DoubleTap;

use YAMLish;

sub get-conf is export {

  my $conf-file = %*ENV<HOME> ~ '/doubletap.yaml';

  my %conf = $conf-file.IO ~~ :f ?? load-yaml($conf-file.IO.slurp) !! Hash.new;

  #warn "rakudist web conf loaded: ", $conf-file;

  %conf;

}

sub http-root is export {

  %*ENV<DT_HTTP_ROOT> || "";

}