use lib '..';
use OmegaTV;
use Data::Dumper;
use Mojo::AsyncAwait;

my $omega_api_client = new OmegaTV({
  api_host        => 'https://api.beta.hls.tv',
  api_public_key  => 'public_superkey',
  api_private_key => 'private_megakey',
});

async(sub { print Dumper(await $omega_api_client->get_tariff_base()) })->()->wait;
