# BDD Scenarios: Super App Features Migration

- **Epic:** `super_app_features_migration`
- **Platform:** Flutter Super App (Clean Architecture + MVI)
- **Status:** Approved (Stage 2)

---

## Use Case 1: Application Launch & Onboarding Flow (`features/onboard`)

### 1.1 Happy Paths
```gherkin
Scenario: [Tier A - Unit] Initial app launch navigates to splash and delays for initialization
  Given the app is launched fresh
  When SplashBloc receives started action
  Then it emits loading state with initial assets loaded
  And after 1500 milliseconds it emits route navigation ready event
```

```gherkin
Scenario: [Tier C - Integration] Fresh user without active session is routed to Login
  Given the user has no saved session token in secure storage
  When the app finishes splash bootstrapping
  Then the router redirects to "/login" (LoginRoute)
```

```gherkin
Scenario: [Tier C - Integration] Returning user with active session is routed to Super App Shell
  Given the user has a valid unexpired session token in secure storage
  When the app finishes splash bootstrapping
  Then the router redirects to "/home" (ShellRoute)
```

### 1.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] Rapid restart during splash delay
  Given SplashBloc is in the middle of waiting for timer completion
  When another started action is dispatched before timer finishes
  Then the second action is ignored or cancelled cleanly without duplicate navigation events
```

### 1.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] State transition from Initial -> Loading -> NavigationReady
  Given SplashBloc is in initial state
  When started action is processed
  Then state changes to loading
  And subsequently emits SplashEvent.navigateToLogin or SplashEvent.navigateToHome
```

### 1.4 Async / Race Conditions
```gherkin
Scenario: [Tier A - Unit] DeepLink arrives while splash is bootstrapping
  Given the app is cold-starting via a deep link URL
  When SplashBloc completes initialization
  Then DeepLinkCoordinator dispatches the queued route after Shell is ready
```

### 1.5 Failures & Storage Resilience
```gherkin
Scenario: [Tier A - Unit] Corrupted local preferences during onboarding check
  Given SharedPreferences storage throws a read exception
  When SplashBloc checks onboarding completion flag
  Then it gracefully falls back to default unauthenticated state and routes to Login
```

---

## Use Case 2: Authentication & Token Management (`features/authentication`)

### 2.1 Happy Paths
```gherkin
Scenario: [Tier A - Unit] User submits valid username and password
  Given valid credentials "demo@example.com" and "Secret123!"
  When LoginBloc processes loginSubmitted action
  Then it emits loading state
  And calls LoginUseCase successfully
  And stores auth token in secure storage
  And emits loginSuccess event to navigate to Shell
```

### 2.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] User submits empty or malformed email
  Given an empty username "" or invalid email "invalid-email"
  When LoginBloc processes loginSubmitted action
  Then it emits error state with validation error code
  And does NOT trigger remote network call
```

```gherkin
Scenario: [Tier A - Unit] Maximum password length boundary
  Given a password string with boundary length 128 characters
  When LoginBloc validates inputs
  Then input validation passes successfully
```

### 2.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] Login state transitions during submission lifecycle
  Given LoginBloc is in idle state with valid inputs
  When loginSubmitted action is dispatched
  Then state transitions: idle -> loading -> success
```

```gherkin
Scenario: [Tier A - Unit] Login failure transitions to error state and preserves username
  Given LoginBloc is in loading state
  When LoginUseCase throws invalid credentials exception
  Then state transitions: loading -> failure(errorMessage: "Invalid credentials")
  And previously entered username is preserved
```

### 2.4 Async / Race Conditions
```gherkin
Scenario: [Tier A - Unit] Rapid consecutive taps on Login button
  Given LoginBloc is currently executing a remote login request
  When user taps the login button 3 times rapidly
  Then subsequent tap actions are dropped by droppable transformer until completion
```

### 2.5 Failures & Network Resilience
```gherkin
Scenario: [Tier A - Unit] Network timeout during login request
  Given remote authentication service times out (408 or connection timeout)
  When LoginBloc processes the response
  Then state transitions to failure with localized network timeout message
  And retry action is available
```

---

## Use Case 3: Wallet Dashboard & Portfolio Ledger (`features/wallet`)

### 3.1 Happy Paths
```gherkin
Scenario: [Tier A - Unit] WalletBloc fetches balance and token list on startup
  Given the user is on the Wallet tab
  When WalletBloc processes started action
  Then it emits loading state
  And fetches wallet data, token accounts, and NFT collections
  And emits loaded state with aggregated balance and currency symbol
```

```gherkin
Scenario: [Tier C - Integration] User selects network from NetworkSelectionPage
  Given the user opens NetworkSelectionPage from Wallet header
  When user selects "Solana Devnet"
  Then selected network updates in local storage
  And WalletBloc refreshes balance for the selected network
```

### 3.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] Wallet with zero tokens and zero NFTs
  Given remote wallet service returns empty lists for tokens and nfts
  When WalletBloc parses response
  Then state displays total balance of 0.00 and shows empty state placeholder
```

```gherkin
Scenario: [Tier A - Unit] Large balance number formatting
  Given balance is a large decimal "1234567890.987654321"
  When formatCurrency helper is invoked
  Then formatted string maintains precision without exponent truncation
```

### 3.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] Pull to refresh state lifecycle
  Given WalletBloc is in loaded state
  When refreshRequested action is received
  Then isRefreshing flag becomes true without clearing existing data
  And once fetch resolves, data is updated and isRefreshing returns to false
```

### 3.4 Async / Race Conditions
```gherkin
Scenario: [Tier A - Unit] Network switch during active balance refresh
  Given WalletBloc is fetching data for "Mainnet"
  When user rapidly switches network to "Testnet"
  Then the in-flight Mainnet request is cancelled and Testnet request takes priority
```

### 3.5 Failures & Storage Resilience
```gherkin
Scenario: [Tier A - Unit] Wallet API returns 500 Server Error
  Given remote wallet client returns HTTP 500
  When WalletBloc handles failure
  Then state transitions to error state with retry button
  And previously cached local balance is shown if available
```

---

## Use Case 4: Transaction Ledger & Transfer Flow (`features/transaction`)

### 4.1 Happy Paths
```gherkin
Scenario: [Tier A - Unit] TransactionBloc loads paginated transaction history
  Given the user switches to Transaction tab
  When TransactionBloc processes started action
  Then it emits loading state
  And loads first 20 transactions categorized by incoming/outgoing
  And displays transaction items with timestamp, amount, and recipient
```

```gherkin
Scenario: [Tier C - Integration] User taps transaction item to view details
  Given the transaction list is populated
  When user taps transaction item with hash "0xabc123"
  Then router pushes TransactionDetailsRoute with transaction argument
  And details page renders metadata, fee, and explorer link
```

### 4.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] Empty transaction history
  Given user has never made any transactions
  When TransactionBloc receives empty list
  Then it displays localized empty ledger message without error toast
```

### 4.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] Filter by transaction type
  Given TransactionBloc is loaded with 15 mixed transactions
  When filterChanged(type: outgoing) action is received
  Then state filters items displaying only outgoing transactions
```

### 4.4 Async / Race Conditions
```gherkin
Scenario: [Tier A - Unit] Infinite scroll pagination debouncing
  Given user scrolls rapidly to the bottom of the list
  When multiple loadMore actions are emitted in under 300ms
  Then pagination requests are throttled to prevent duplicate page fetches
```

### 4.5 Failures & Storage Resilience
```gherkin
Scenario: [Tier A - Unit] Offline state during transaction fetch
  Given device has no internet connection
  When TransactionBloc tries to load transactions
  Then it emits offline error banner and serves cached transactions from local database
```

---

## Use Case 5: Market Trends & Analytics (`features/trends`)

### 5.1 Happy Paths
```gherkin
Scenario: [Tier A - Unit] TrendsBloc fetches cryptocurrency market rates
  Given user navigates to Trends tab
  When TrendsBloc processes started action
  Then it loads market prices, 24h percentage change, and sparkline points
  And renders trend items with positive/negative color indicators
```

### 5.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] Flat price change (0.00% change)
  Given a token price with exactly 0.00% 24h change
  When trend widget renders indicator
  Then it displays neutral gray color indicator instead of red or green
```

### 5.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] Timeframe filter switching (1D, 1W, 1M, 1Y)
  Given TrendsBloc is displaying 1D chart data
  When timeframeChanged(timeframe: 1M) is dispatched
  Then state transitions to chartLoading then renders 1M chart points
```

### 5.4 Async / Race Conditions
```gherkin
Scenario: [Tier A - Unit] Rapid timeframe switching
  Given user quickly taps 1D, 1W, 1M in sequence
  When multiple requests are initiated
  Then restartable transformer cancels earlier fetches and displays only 1M data
```

### 5.5 Failures & Storage Resilience
```gherkin
Scenario: [Tier A - Unit] Rate limiting (HTTP 429) from market API
  Given market API responds with 429 Too Many Requests
  When TrendsBloc handles error
  Then it shows rate-limited warning and backs off polling interval
```

---

## Use Case 6: Super App Host Shell & MiniApp Fault Isolation

### 6.1 Happy Paths
```gherkin
Scenario: [Tier C - Integration] ShellPage renders 5 tabs and allows seamless switching
  Given user is authenticated in ShellPage
  When user taps tabs in order: 0 (Wallet) -> 1 (Transaction) -> 2 (Scanner) -> 3 (Trends) -> 4 (Settings)
  Then IndexedStack switches currentTabIndex smoothly
  And each respective Mini-App page maintains its state
```

### 6.2 Edge Cases & Boundaries
```gherkin
Scenario: [Tier A - Unit] MiniAppErrorBoundary catches unhandled render exception
  Given WalletPage encounters an unexpected null assertion crash in widget build
  When MiniAppErrorBoundary intercepts the error
  Then the error is caught locally without crashing the entire Flutter app
  And a localized fallback card with "Reload Mini-App" button is shown in Tab 0
  And the user can still switch to Scanner, Trends, or Settings tabs normally
```

### 6.3 State Transitions
```gherkin
Scenario: [Tier A - Unit] Double tap on active bottom bar tab scrolls to top
  Given user is scrolled down on Tab 0 (WalletPage)
  When user taps Tab 0 icon again (double tap)
  Then ShellBloc emits tabDoubleTapped action
  And scroll controller scrolls back to top smoothly
```

### 6.4 Async / Race Conditions
```gherkin
Scenario: [Tier C - Integration] Rapid tab switching during data load
  Given user is loading Wallet data on Tab 0
  When user rapidly taps Tab 1 then Tab 3 then Tab 0
  Then the shell maintains correct index and active tab renders without graphical glitch
```

### 6.5 Failures & Storage Resilience
```gherkin
Scenario: [Tier C - Integration] DeepLink navigation while app is backgrounded
  Given app is in background with Shell active
  When a deep link "app://wallet/transaction/123" is received
  Then deep link coordinator switches to Tab 1 and pushes TransactionDetailsRoute
```
