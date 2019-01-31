package OmegaTV;

use strict;

use URI;
use URI::QueryParam;
use Mojo::UserAgent;
use Mojo::AsyncAwait;
use Mojo::JSON qw/j/;
use Digest::SHA qw/hmac_sha256_hex/;


sub new {
  my ($class, $arg) = @_;

  my $self = {
    user_agent      => Mojo::UserAgent->new,
    api_host        => $arg->{api_host},
    api_public_key  => $arg->{api_public_key},
    api_private_key => $arg->{api_private_key}
  };

  $self->{user_agent}->max_response_size(0);

  return bless $self, 'OmegaTV';
}


async _request => sub {
  my $self   = shift;
  my $route  = shift;
  my $data   = shift || {};
  my $method = shift || 'POST';
  my $time   = time();

  my $uri = URI->new('', 'http');

  $uri->query_param($_, $data->{$_}) foreach (keys %$data);
  my $params = $uri->query || '';

  my $message = $time . $self->{api_public_key} . $params;
  my $hash    = hmac_sha256_hex($message, $self->{api_private_key});
  my $url     = $self->{api_host} . $route;

  my $tx = $self->{user_agent}->build_tx($method => $url => {
    'API_ID'       => $self->{api_public_key},
    'API_TIME'     => $time,
    'API_HASH'     => $hash,
    'Content-Type' => 'application/x-www-form-urlencoded'
  } => $params);

  await ($self->_response($tx))->();
};


async _response => sub {
  my $self = shift;
  my $tx   = shift;

  await $self->{user_agent}->start_p($tx);

  return async(sub {
    my $success = $tx->result;

    my $response = {
      error => undef
    };

    if ($success) {
      my $data = j($success->body);

      if ($data->{error}) {
        $response->{error}      = $data->{error}->{msg};
        $response->{error_code} = $data->{error}->{code};
      } else {
        $response->{data} = $data->{result};
      }
    } else {
      my $error = $tx->result->{error};

      $response->{error_code} = $error->{code} || 500;
      $response->{error}      = $error->{message};
    }

    return $response;
  });
};


async get_tariff_base => sub {
  my $self = shift;

  await $self->_request('/tariff/base/list');
};


async get_tariff_promo => sub {
  my $self = shift;

  await $self->_request('/tariff/promo/list');
};


async get_tariff_bundle => sub {
  my $self = shift;

  await $self->_request('/tariff/bundle/list');
};


async get_customer => sub {
  my $self        = shift;
  my $customer_id = shift;

  await $self->_request('/customer/get', { customer_id => $customer_id });
};


async set_customer_tariff => sub {
  my $self              = shift;
  my $customer_id       = shift;
  my $base_tariff_id    = shift;
  my $bundle_tariff_id  = shift;

  my $params = {
    customer_id => $customer_id,
    base        => $base_tariff_id
  };

  $params->{bundle} = $bundle_tariff_id
    if $bundle_tariff_id;


  await $self->_request('/customer/tariff/set', $params);
};


async block_customer => sub {
  my $self        = shift;
  my $customer_id = shift;

  await $self->_request('/customer/block', { customer_id => $customer_id });
};


async activate_customer => sub {
  my $self        = shift;
  my $customer_id = shift;

  await $self->_request('/customer/activate', { customer_id => $customer_id });
};


async get_customer_device_code => sub {
  my $self        = shift;
  my $customer_id = shift;

  await $self->_request('/customer/device/get_code', { customer_id => $customer_id });
};


async remove_customer_device => sub {
  my $self        = shift;
  my $customer_id = shift;
  my $uniq        = shift;

  await $self->_request('/customer/device/remove', { customer_id => $customer_id, uniq => $uniq });
};


async add_customer_device => sub {
  my $self        = shift;
  my $customer_id = shift;
  my $uniq        = shift;

  await $self->_request('/customer/device/add', { customer_id => $customer_id, uniq => $uniq });
};


async get_device_list => sub {
  my $self = shift;

  await $self->_request('/device/list');
};


1;
