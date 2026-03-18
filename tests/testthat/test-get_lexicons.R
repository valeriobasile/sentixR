test_that("get_sentix works correctly", {
    skip_if_not(exists("sentix"), "sentix dataset not loaded")

    # Default
    df <- get_sentix()
    expect_true(is.data.frame(df))
    expect_equal(names(df), c("lemma", "score"))

    # Polarity
    df_pol <- get_sentix(polarity = TRUE)
    expect_true("polarity" %in% names(df_pol))
    expect_false("score" %in% names(df_pol)) # removed by default when polarity=T? check implementation

})

test_that("get_elita works correctly", {
    skip_if_not(exists("elita_VAD"), "elita_VAD dataset not loaded")

    # Default
    df <- get_elita("elita_VAD")
    expect_true(is.data.frame(df))
    expect_true("valenza" %in% names(df))

    # Rescale validation
    expect_error(get_elita(rescale = "invalid"), "Unsupported rescaling")

    # Basic
    skip_if_not(exists("elita_basic"), "elita_basic dataset not loaded")
    df_basic <- get_elita("elita_basic")
    expect_true(is.data.frame(df_basic))
})
