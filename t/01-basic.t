use strict;
use warnings;

use Test::More 0.96 import => ['!pass'];

use File::Spec;
use HTTP::Cookies;
use HTTP::Request::Common;
use Plack::Test;

{

    package MyTestApp;
    use Dancer2;
    use Dancer2::Plugin::Locale::Wolowitz;

    set confdir  => '.';
    set template => 'template_toolkit';
    set plugins  => {
        'Locale::Wolowitz' => {
            fallback       => "en",
            lang_available => [qw( en fr )],
        }
    };

    @{ engine('template')->config }{qw(start_tag end_tag)} = qw(<% %>);

    set session => 'Simple';

    get '/' => sub {
        session lang => param('lang');
        my $tr = loc('welcome');
        return $tr;
    };

    get '/tmpl' => sub {
        template 'index', {}, { layout => undef };
    };

    get '/no_key' => sub {
        my $tr = loc('hello');
        return $tr;
    };

    get '/tmpl/no_key' => sub {
        template 'no_key';
    };

    get '/complex_key' => sub {
        my $tr = loc( 'path_not_found %1', [ setting('appdir') ] );
        return $tr;
    };

    get '/tmpl/complex_key' => sub {
        template 'complex_key', { appdir => setting('appdir') };
    };
}

my $url  = "http://localhost";
my $jar  = HTTP::Cookies->new();
my $test = Plack::Test->create( MyTestApp->to_app );

my ( $req, $res );

$res = $test->request( GET "$url/?lang=en" );
is $res->content, 'Welcome', 'check simple key english';
$jar->extract_cookies($res);

$req = GET "$url/tmpl";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'Welcome', 'check simple key english (tmpl)';

$req = GET "$url/no_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'hello', 'check no key found english';

$req = GET "$url/tmpl/no_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'hello', 'check no key found english (tmpl)';

my $path = File::Spec->rel2abs('t');
$req = GET "$url/complex_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, "$path not found", 'check complex key english';

$req = GET "$url/tmpl/complex_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, "$path not found", 'check complex key english (tmpl)';

# and now for something completely different
$req = GET "$url/?lang=fr";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'Bienvenue', 'check simple key french';

$req = GET "$url/tmpl";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'Bienvenue', 'check simple key french (tmpl)';

$req = GET "$url/no_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'hello', 'check no key found french';

$req = GET "$url/tmpl/no_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, 'hello', 'check no key found french (tmpl)';

$req = GET "$url/complex_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, "Repertoire $path non trouve", 'check complex key french';

$req = GET "$url/tmpl/complex_key";
$jar->add_cookie_header($req);
$res = $test->request($req);
is $res->content, "Repertoire $path non trouve",
  'check complex key french (tmpl)';

# and test allowed langs
$jar->clear;
$req = GET "$url/tmpl", 'Accept-Language' => "it,de;q=0.8,es;q=0.5";
$res = $test->request($req);
is $res->content, 'Welcome', 'check simple key english (fallback)';

$jar->clear;
$req = GET "$url/tmpl", 'Accept-Language' => "it,de;q=0.8,es;q=0.5,fr;0.2";
$res = $test->request($req);
is $res->content, 'Bienvenue', 'check simple key french (accept-language)';

done_testing;
