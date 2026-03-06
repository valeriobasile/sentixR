test_that(".check_quanteda_pkgs errors when packages are missing", {
    # Mock requirement failure
    mockery::stub(.check_quanteda_pkgs, "requireNamespace", FALSE)
    expect_error(.check_quanteda_pkgs(), "Package `quanteda` is required")
})

test_that(".find_word_field selects correct column", {
    # 1. Explicit argument
    expect_equal(.find_word_field(data.frame(a = 1), "my_col"), "my_col")

    # 2. Lemma
    df_lemma <- data.frame(lemma = c("a"), word = c("b"), stringsAsFactors = FALSE)
    expect_equal(.find_word_field(df_lemma, NULL), "lemma")

    # 3. Word
    df_word <- data.frame(word = c("b"), other = c("c"), stringsAsFactors = FALSE)
    expect_equal(.find_word_field(df_word, NULL), "word")

    # 4. First character column
    df_char <- data.frame(score = 1, term = "cloud", stringsAsFactors = FALSE)
    expect_equal(.find_word_field(df_char, NULL), "term")

    # 5. Fail
    df_fail <- data.frame(score = 1)
    expect_error(.find_word_field(df_fail, NULL), "No character column found")
})

test_that(".validate_arg checks choices", {
    expect_silent(.validate_arg("a", c("a", "b"), "arg"))
    expect_error(.validate_arg("c", c("a", "b"), "arg"), "Unsupported arg")
})
