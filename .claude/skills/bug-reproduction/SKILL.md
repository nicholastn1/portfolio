# Skill: Bug Reproduction

## When to Use

- You encounter a bug that needs fixing
- You're working on a bug report or issue
- Before attempting ANY fix — always reproduce first
- When using the `/fix-bug` command

## Test Framework

- **Framework:** Minitest (Rails default)
- **Run command:** `bin/rails test` (or `docker compose exec app bin/rails test`)
- **Test directory:** `test/` (models, controllers, integration, helpers, mailers, system)
- **E2E Framework:** Capybara + Selenium WebDriver
- **E2E Run command:** `bin/rails test:system`
- **E2E Test directory:** `test/system/`

## How to Reproduce a Bug

### Step 1: Understand the Bug

Read the bug description carefully. Identify:
- **Expected behavior:** What should happen?
- **Actual behavior:** What happens instead?
- **Trigger conditions:** When does it occur? (specific input, state, timing)

Check for additional context:
- Error logs or stack traces
- Screenshots or recordings
- Related GitHub issues or PRs

### Step 2: Locate the Code

Search for the affected code path:

```bash
# Search by error message
grep -r "error message text" app/

# Search by function/method name
grep -r "method_name" app/

# Search by route/endpoint
grep -r "route_path" config/routes.rb
```

Read the code and trace the execution path from trigger to failure.

### Step 3: Write a Failing Test

Write a test that:
1. Sets up the conditions that trigger the bug
2. Performs the action that causes the failure
3. Asserts the EXPECTED (correct) behavior

The test must **FAIL** — proving the bug exists.

```ruby
# test/models/example_test.rb
require "test_helper"

class ExampleTest < ActiveSupport::TestCase
  test "should [expected behavior] when [condition]" do
    # Arrange: set up the conditions
    record = ModelName.new(field: "value")

    # Act: perform the action that triggers the bug
    result = record.some_method

    # Assert: check for correct behavior (this should FAIL)
    assert_equal expected_value, result
  end
end
```

For controller/integration bugs:

```ruby
# test/controllers/admin/examples_controller_test.rb
require "test_helper"

class Admin::ExamplesControllerTest < ActionDispatch::IntegrationTest
  test "should [expected behavior]" do
    post admin_login_path, params: { email: "admin@nicholasnogueira.dev", password: "changeme123" }
    get admin_examples_path
    assert_response :success
  end
end
```

### Step 4: Verify the Failure

Run the test and confirm it fails:

```bash
# Run the specific test file
bin/rails test test/models/example_test.rb

# Run a specific test by line number
bin/rails test test/models/example_test.rb:5
```

Check that the test fails for the RIGHT reason:
- The assertion should fail because of the bug, not because of a typo in the test
- The error message should relate to the actual bug behavior
- If the test passes, the bug is not reproduced — revisit Step 1

### Step 5: Fix and Verify

After implementing the fix:
1. Run the reproduction test — it should now PASS
2. Run the full test suite — no regressions

```bash
# Run reproduction test
bin/rails test test/models/example_test.rb

# Run full suite
bin/rails test
```

## Anti-Patterns

- Don't mock the bug away — test the real code path
- Don't write a test that passes — it must FAIL first
- Don't fix the bug before writing the test
- Don't write overly broad tests — isolate the specific bug
- Don't skip running the test before fixing — you need to SEE it fail
- Don't assume the first failure is the right failure — verify the error relates to the bug

## UI Bugs

### Markdown Test Plans

When the bug involves UI behavior that can't easily be unit tested, create a test plan document:

```markdown
## Test Plan: [Bug Description]

### Steps to Reproduce
1. Navigate to [URL/page]
2. [Action 1]
3. [Action 2]
4. Expected: [what should happen]
5. Actual: [what happens instead]

### Validation Method
- [ ] Screenshot comparison
- [ ] DOM element assertion
- [ ] Network request validation
- [ ] Console error check
```

### Browser Validation

- Prefer screenshots over selector-based assertions (less fragile)
- Run browser checks in subagents for isolation
- Document visual references with file paths

### E2E Test Patterns

- **E2E Framework:** Capybara + Selenium WebDriver
- **Run command:** `bin/rails test:system`
- **Test directory:** `test/system/`

## Examples from This Codebase

Test helper setup (`test/test_helper.rb`):
```ruby
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end
```
