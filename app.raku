use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use DoubleTap;
use DoubleTap::HTML;
use File::Temp;

my $application = route {

  get -> {
    template 'templates/main.crotmp', %( 
      css => css(), 
      navbar => navbar(), 
    )
  }

  get -> 'examples', {
    template 'templates/examples.crotmp', %( 
      css => css(), 
      navbar => navbar(),
      examples => "examples.md".IO.slurp, 
    )
  }

  post -> 'api', {
    request-body -> %json {
      content 'application/json', %json;
      my $check_id = %json<check_id>;
      my $data = %json<data>;
      my $desc = %json<desc>;
      if "checks/{$check_id}/task.check".IO ~~ :f {
        my $tmpdir = tempdir;
        copy "checks/{$check_id}/task.check", "$tmpdir/task.check";
        if "checks/{$check_id}/config.yaml".IO ~~ :f {
          copy "checks/{$check_id}/config.yaml", "$tmpdir/config.yaml";
        }
        "$tmpdir/data.txt".IO.spurt($data);
        "$tmpdir/task.bash".IO.spurt("cat data.txt");
        my $s6-cmd = "cd $tmpdir && s6 --task-run .";
        if %json<params> {
          $s6-cmd ~= "\@{%json<params>}";
        }
        $s6-cmd ~= " 2>\&1; echo \$?";
        my $out = qqx[$s6-cmd];
        my $status = True;
        my $ex-code = Int($out.chomp.split(/\n/).tail);
        if $$ex-code != 0 {
            say "Out: " ~ $out;
            say "Command failed with exit code: " ~ $ex-code;
            $status = False;
        }
        my %res = %( 
          status => ( $status == True ?? "OK" !! "FAIL" ), 
          report => $out,
          check => $check_id,
          desc => $desc,
        );
        content 'application/json', %res; 
      } else {
        not-found();
      }
    }
  }

  #
  # Static files methods
  #

  get -> 'js', *@path {
    cache-control :public, :max-age(300);
    static 'js', @path;
  }

  get -> 'css', *@path {
    cache-control :public, :max-age(10);
    static 'css', @path;
  }

  #
  # End of Static files methods
  #

}

my Cro::Service $service = Cro::HTTP::Server.new:
    :host(%*ENV<DT_HOST> || "localhost"), :port(%*ENV<DT_PORT> || 9191), :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}

