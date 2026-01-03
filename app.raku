use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use DoubleTap;
use DoubleTap::HTML;

my $application = route {

  get -> {
    template 'templates/main.crotmp', %( 
      css => css(), 
      navbar => navbar(), 
    )
  }

  get -> 'boxes', {
    template 'templates/examples.crotmp', %( 
      css => css(), 
      navbar => navbar(),
      examples => "examples.md".IO.slurp, 
    )
  }

  post -> 'api', {
    request-body -> %json {
      content 'application/json', %json;
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

