use strict;
use warnings;

our $VERSION = '1.1.0';

use 5.14.2;

use JSON::RPC::Dispatch;
use Router::Simple::Declare;
use JSON::PP;
use POSIX;

use Plack::Builder;

BEGIN { $ENV{PERL_JSON_BACKEND} = 'JSON::PP' };

use Zonemaster::WebBackend::Engine;

local $| = 1;

builder {
	enable 'Debug',
};

my $router = router {
############## FRONTEND ####################
	connect "version_info" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "version_info"
	};

	connect "get_ns_ips" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_ns_ips"
	};

	connect "get_data_from_parent_zone" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_data_from_parent_zone"
	};

	connect "validate_syntax" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "validate_syntax"
	};
	
	connect "start_domain_test" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "start_domain_test"
	};
	
	connect "test_progress" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "test_progress"
	};
	
	connect "get_test_params" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_test_params"
	};

	connect "get_test_results" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_test_results"
	};

	connect "get_test_history" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_test_history"
	};
	
	connect "check_test_exist" => {
                handler => "+Zonemaster::WebBackend::Engine",
                action => "check_test_exist"
        };

############ BATCH MODE ####################

	connect "add_api_user" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "add_api_user"
	};

	connect "add_batch_job" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "add_batch_job"
	};

	connect "get_batch_job_result" => {
		handler => "+Zonemaster::WebBackend::Engine",
		action => "get_batch_job_result"
	};
};

my $dispatch = JSON::RPC::Dispatch->new(
	router => $router,
);

sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    eval {
		my $json = $req->content;
		my $content = decode_json($json);
	};
    
    $dispatch->handle_psgi($env, $env->{REMOTE_HOST} );
};
