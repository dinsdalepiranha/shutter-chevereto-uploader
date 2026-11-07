#! /usr/bin/env perl

package Chevereto;

use lib $ENV{'SHUTTER_ROOT'} . '/share/shutter/resources/modules';

use strict;
use warnings;
use POSIX qw/setlocale/;
use Locale::gettext;
use Glib qw/TRUE FALSE/;
use Shutter::Upload::Shared;
our @ISA = qw(Shutter::Upload::Shared);

use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON::PP qw(decode_json);


my $d = Locale::gettext->domain("shutter-plugins");
$d->dir($ENV{'SHUTTER_INTL'});

my %upload_plugin_info = (
    'module'                       => 'Chevereto',
    'url'                          => '',
    'registration'                 => '',
    'name'                         => 'Chevereto',
    'description'                  => 'Upload screenshots to Chevereto. Username: https://example.com Password: YOUR_API_KEY',
    'supports_anonymous_upload'    => FALSE,
    'supports_authorized_upload'   => TRUE,
    'supports_oauth_upload'        => FALSE,
);

binmode(STDOUT, ':utf8');
if (exists $upload_plugin_info{$ARGV[0]}) {
    print $upload_plugin_info{$ARGV[0]};
    exit;
}

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(shift, shift, shift, shift, shift, shift);
    bless $self, $class;
    return $self;
}

sub init {
    return TRUE;
}

sub upload {
    my ($self, $upload_filename, $username, $password) = @_;

    my $base_url = $username // '';
    my $api_key  = $password // '';

    $base_url =~ s{/+$}{};

    unless ($base_url =~ m{^https://}i && length $api_key) {
        $self->{_links}->{status} =
            'Enter the Chevereto HTTPS base URL as Username and the API key as Password.';
        return %{ $self->{_links} };
    }

    my $endpoint = $base_url . '/api/1/upload';
    my $ua = LWP::UserAgent->new(
        timeout    => 120,
        keep_alive => 1,
        env_proxy  => 1,
        agent      => 'Shutter-Chevereto-Plugin/1.0',
    );

    my $response;
    eval {
        my $request = POST(
            $endpoint,
            'X-API-Key' => $api_key,
            Content_Type => 'form-data',
            Content      => [
                source => [$upload_filename],
            ],
        );

        $response = $ua->request($request);

        die 'Chevereto returned HTTP ' . $response->code
            . ': ' . $response->decoded_content
            unless $response->is_success;

        my $json = decode_json($response->decoded_content);

        # Chevereto API v1.1 image upload response.
        my $image = $json->{image}
            || ($json->{data} && $json->{data}->{image});

        die 'Upload succeeded, but the response did not contain image details'
            unless ref($image) eq 'HASH';

        my $url = $image->{url}
            || $image->{url_viewer}
            || $image->{display_url}
            || $image->{image_url};

        die 'Upload succeeded, but no image URL was found in the response'
            unless defined($url) && length($url);

        $self->{_links}->{direct_link} = $url;
        $self->{_links}->{short_link}  = $url;
        $self->{_links}->{bbcode}      = '[img]' . $url . '[/img]';
        $self->{_links}->{status}      = 200;
    };

    if ($@) {
        my $error = $@ || 'Unknown upload error';
        $error =~ s/\s+$//;
        $self->{_links}->{status} = $error;
    }

    return %{ $self->{_links} };
}

1;
