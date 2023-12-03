package MyCGIApp;

use strict;
use utf8;

use base qw(CGI::Application); # make sure this occurs before you load the plugin

use CGI::Application::Plugin::Authentication;
use HTML::Template;

__PACKAGE__->authen->config(
    LOGIN_RUNMODE => 'start',
    DRIVER => [ 'Generic', { user1 => '123' } ],
    STORE => 'Session',
    POST_LOGIN_RUNMODE => 'auth_logout',
    LOGOUT_RUNMODE => 'logout'
);

__PACKAGE__->authen->protected_runmodes(qr/^auth_/);

sub setup($) {
    my $self = shift;
    $self->header_props(-type => 'text/html; charset=UTF-8');
    $self->start_mode('start') unless $self->get_current_runmode;
    $self->mode_param('rm');
    $self->run_modes(['start', 'auth_logout']);
}

sub start($) {
    my $self = shift;
    my $head = $self->load_tmpl('head.tmpl', utf8 => 1);
    $head->param(LANG => 'ja');
    $head->param(CHARSET => 'UTF-8');
    $head->param(TITLE => 'ログイン');
    my $output = $head->output;

    my $form = $self->load_tmpl('login.tmpl', utf8 => 1);
    $form->param(METHOD => 'POST');
    $output .= $form->output;
    my $foot = $self->load_tmpl('foot.tmpl', utf8 => 1);
    $output .= $foot->output;
    return $output;
}

sub auth_logout($) {
    my $self = shift;
    # The user should be logged in if we got here
    my $username = $self->authen->username;
    my $head = $self->load_tmpl('head.tmpl', utf8 => 1);
    $head->param(LANG => 'ja');
    $head->param(CHARSET => 'UTF-8');
    $head->param(TITLE => $username);
    my $output = $head->output;

    my $form = $self->load_tmpl('logout.tmpl', utf8 => 1);
    $form->param(METHOD => 'POST');
    $output .= $form->output;
    my $foot = $self->load_tmpl('foot.tmpl', utf8 => 1);
    $output .= $foot->output;
    return $output;

}

1;

__END__

=pod

=encoding utf8

=head1 NAME

MyCGIApp - My CGI

=head1 SEE ALSO

 * <https://metacpan.org/pod/CGI::Application>
 * <https://metacpan.org/pod/CGI::Application::Plugin::Authentication>
 