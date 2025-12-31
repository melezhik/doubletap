unit module DoubleTap::HTML;

use DoubleTap;

my $bulma-version = "1.0.4";

sub css () is export {

  my %conf = get-conf();

  qq:to /HERE/
  <meta charset="utf-8">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma\@{$bulma-version}/css/bulma.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/perl.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/yaml.min.js"></script>
  <script>hljs.initHighlightingOnLoad();</script>
  <script src="/js/fix_navbar.js" type="text/javascript"></script>
  HERE

}

sub navbar () is export {

  qq:to /HERE/
    <nav class="navbar is-transparent" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
       <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>
      <div id="navbarBasicExample" class="navbar-menu">
        <div class="navbar-start">
          <a class="navbar-item" href="{http-root()}/projects">
            Projects
          </a>
          <a class="navbar-item" href="{http-root()}/builds_latest">
            Recent Builds
          </a>
          <a class="navbar-item" href="{http-root()}/builds">
            All Builds
          </a>
          <a class="navbar-item" href="{http-root()}/queue">
            Queue
          </a>
          <div class="navbar-item has-dropdown is-hoverable">
            <a class="navbar-link">
              More
            </a>
            <div class="navbar-dropdown">
              <a class="navbar-item" href="{http-root()}/about">
                About
              </a>
              <a class="navbar-item" href="https://github.com/melezhik/sparky">
                Docs
              </a>
              <a class="navbar-item" href="https://github.com/melezhik/sparky/issues">
                Report an issue
              </a>
            </div>
          </div>
        </div>
      </div>
    </nav>
  HERE

}
