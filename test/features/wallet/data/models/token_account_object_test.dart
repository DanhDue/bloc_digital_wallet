import 'package:bloc_digital_wallet/features/wallet/data/models/mint_token_object.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/token_account_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TokenAccountObject', () {
    final json = {
      "address": "EZUUg4Ps2n4saY2WXj34iMdiL65765bLgka39DgFJ7y8",
      "owner": "CRG9hpv6WpMHhiNZKF9XSjTnfS9SavtTJqhTRc3xG4GZ",
      "amount": 102.746191,
      "mint_token": {
        "address": "BRjpCHtyQLNCo8gqRUr8jtdAj5AjPYQaoqbvcZiHok1k",
        "decimals": 6,
        "supply": 20601787343257,
        "is_initialized": 1,
        "mint_authority": "3otH3AHWqkqgSVfKFkrxyDqd2vK6LcaqigHrFEmWcGuo",
        "update_authority": "3otH3AHWqkqgSVfKFkrxyDqd2vK6LcaqigHrFEmWcGuo",
        "name": "devUSDC",
        "symbol": "devUSDC",
        "uri": "https://everlastingsong.github.io/nebula/devtoken_metadata/devUSDC/token_metadata.json",
        "logo": "https://everlastingsong.github.io/nebula/devtoken_metadata/devUSDC/image.png",
        "is_mutable": false
      },
      "account_owner": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
    };

    test('fromJson creates a valid instance', () {
      final tokenAccount = TokenAccountObject.fromJson(json);

      expect(tokenAccount.address, "EZUUg4Ps2n4saY2WXj34iMdiL65765bLgka39DgFJ7y8");
      expect(tokenAccount.owner, "CRG9hpv6WpMHhiNZKF9XSjTnfS9SavtTJqhTRc3xG4GZ");
      expect(tokenAccount.amount, 102.746191);
      expect(tokenAccount.accountOwner, "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA");

      final mintToken = tokenAccount.mintToken;
      expect(mintToken?.address, "BRjpCHtyQLNCo8gqRUr8jtdAj5AjPYQaoqbvcZiHok1k");
      expect(mintToken?.decimals, 6);
      expect(mintToken?.supply, 20601787343257);
      expect(mintToken?.isInitialized, 1);
      expect(mintToken?.mintAuthority, "3otH3AHWqkqgSVfKFkrxyDqd2vK6LcaqigHrFEmWcGuo");
      expect(mintToken?.updateAuthority, "3otH3AHWqkqgSVfKFkrxyDqd2vK6LcaqigHrFEmWcGuo");
      expect(mintToken?.name, "devUSDC");
      expect(mintToken?.symbol, "devUSDC");
      expect(mintToken?.uri, "https://everlastingsong.github.io/nebula/devtoken_metadata/devUSDC/token_metadata.json");
      expect(mintToken?.logo, "https://everlastingsong.github.io/nebula/devtoken_metadata/devUSDC/image.png");
      expect(mintToken?.isMutable, false);
    });
  });
}
