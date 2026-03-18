test_that("df_to_valence creates a dictionary", {
    skip_if_not_installed("quanteda")
    skip_if_not_installed("quanteda.sentiment")

    df <- data.frame(word = c("good", "bad"), score = c(1, -1), stringsAsFactors = FALSE)
    dict <- df_to_valence(df)

    expect_s4_class(dict, "dictionary2")
})

test_that("df_to_polar creates a dictionary", {
    skip_if_not_installed("quanteda")
    skip_if_not_installed("quanteda.sentiment")

    df <- data.frame(word = c("good", "bad"), polarity = c("pos", "neg"), stringsAsFactors = FALSE)
    dict <- df_to_polar(df)

    expect_s4_class(dict, "dictionary2")
})

test_that("df_to_dict auto-detects type", {
    skip_if_not_installed("quanteda")
    skip_if_not_installed("quanteda.sentiment")

    # Valence
    df_val <- data.frame(word = c("good"), score = 1, stringsAsFactors = FALSE)
    dict_val <- df_to_dict(df_val)
    expect_s4_class(dict_val, "dictionary2")

    # Polarity
    df_pol <- data.frame(word = c("good"), polarity = "pos", stringsAsFactors = FALSE)
    dict_pol <- df_to_dict(df_pol, polar_field = "polarity")
    expect_s4_class(dict_pol, "dictionary2")
})
