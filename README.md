# NAME

Dancer2::Plugin::Locale::Wolowitz - Dancer2's plugin for Locale::Wolowitz

# DESCRIPTION

This plugin give you the [Locale::Wolowitz](https://metacpan.org/pod/Locale::Wolowitz) support. It's a blatant copy of
[Dancer::Plugin::Locale::Wolowitz](https://metacpan.org/pod/Dancer::Plugin::Locale::Wolowitz) and should be a drop in replacement
for Dancer2 projects.

# SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::Locale::Wolowitz;

    # in your templates
    get '/' => sub {
        template 'index';
    }

    # or directly in code
    get '/logout' => sub {
        template 'logout', {
            bye => loc('Bye');
        }
    }

... meanwhile, in a nearby template file called index.tt

    <% l('Welcome') %>

# CONFIGURATION

    plugins:
      Locale::Wolowitz:
        fallback: "en"
        locale_path_directory: "i18n"
        lang_session: "lang"
        lang_available:
          - de
          - en
          - id
          - nl

# KEYWORDS

## loc

The `loc` keyword can be used in code to look up the correct translation. In
templates you can use the `l('')` function

# AUTHOR

Menno Blom, `<blom at cpan.org>`

# BUGS / CONTRIBUTING

This module is developed on Github at:
[http://github.com/b10m/p5-Dancer-Plugin-Locale-Wolowitz](http://github.com/b10m/p5-Dancer-Plugin-Locale-Wolowitz)

# ACKNOWLEDGEMENTS

Many thanks go out to [HOBBESTIG](https://metacpan.org/author/HOBBESTIG) for
writing the Dancer 1 version of this plugin ([Dancer::Plugin::Locale::Wolowitz](https://metacpan.org/pod/Dancer::Plugin::Locale::Wolowitz)).

And obviously thanks to [IDOPEREL](https://metacpan.org/author/IDOPEREL) for
creating the main code we're using in this plugin! ([Locale::Wolowitz](https://metacpan.org/pod/Locale::Wolowitz)).

# COPYRIGHT

Copyright 2014- Menno Blom

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
