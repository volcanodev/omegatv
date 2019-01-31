# OmegaTV API client

API client for "Omega TV" OTT service based on Mojo::AsyncAwait and Mojo::UserAgent

# Synopsis

```Perl
use OmegaTV;
use Mojo::AsyncAwait;

my $omega_api_client = new OmegaTV({
  api_host        => 'https://api.beta.hls.tv',
  api_public_key  => 'public_superkey',
  api_private_key => 'private_megakey',
});

async(sub { await $omega_api_client->get_tariff_base() })->()->wait;
```

# Methods

#### get_tariff_base
````perl
$omega_api_client->get_tariff_base()
````

#### get_tariff_promo
````perl
$omega_api_client->get_tariff_promo()
````

#### get_tariff_bundle
````perl
$omega_api_client->get_tariff_bundle()
````

#### get_customer
````perl
$omega_api_client->get_customer($customer_id)
````

#### set_customer_tariff
````perl
$omega_api_client->set_customer_tariff($customer_id, $base_tariff_id, $bundle_tariff_id)
````

#### block_customer
````perl
$omega_api_client->block_customer($customer_id)
````

#### activate_customer
````perl
$omega_api_client->get_customer($customer_id)
````

#### get_customer_device_code
````perl
$omega_api_client->get_customer_device_code($customer_id)
````
#### remove_customer_device
````perl
$omega_api_client->remove_customer_device($customer_id, $uniq)
````

#### add_customer_device
````perl
$omega_api_client->add_customer_device($customer_id, $uniq)
````

#### get_device_list
````perl
$omega_api_client->get_device_list()
````

# Reference
See [Omega TV API Integration Manual](https://omegatv.atlassian.net/wiki/spaces/POT/pages/13926401/API+Integration+Manual) for detailed information.
