unit module DoubleTap::HTML;

use DoubleTap;

my $bulma-version = "1.0.4";

sub css () is export {

  my %conf = get-conf();

  qq:to /HERE/
  <meta charset="utf-8">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma\@{$bulma-version}/css/bulma.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex\@0.15.0/dist/katex.min.css">
  <link rel="stylesheet" href="https://unpkg.com/\@wcj/markdown-to-html/dist/marked.css">
  <link href="/css/main.css" rel='stylesheet'>
  <script src="https://unpkg.com/\@wcj/markdown-to-html/dist/markdown.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/perl.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/bash.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/yaml.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/json.min.js"></script>
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
          <a class="navbar-item" href="{http-root()}/">
            Home
          </a>
          <a class="navbar-item" href="{http-root()}/examples">
            Examples
          </a>
          <a class="navbar-item" href="{http-root()}/checks">
            Checks
          </a>
          <a class="navbar-item" href="{http-root()}/boxes">
            Boxes
          </a>
          <a class="navbar-item" href="{http-root()}/install">
            Install
          </a>
          <a class="navbar-item" href="{http-root()}/bash">
            Bash
          </a>
          <a class="navbar-item" href="https://github.com/melezhik/doubletap">
            Source
          </a>
        </div>
      </div>
    </nav>
  HERE

}
