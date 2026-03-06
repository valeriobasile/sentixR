test_that("make_polarity works with single threshold (legacy)", {
    scores <- c(-1, -0.5, 0, 0.5, 1)

    # Default threshold = 0
    # >= 0 is positive, < 0 is negative? Wait, checking logic:
    # score == 0 ~ "neutral", score >= pos ~ "positive".
    # If threshold=0, pos=0, neg=0.
    # 0 is neutral.
    # 0.5 >= 0 -> positive.
    # -0.5 <= 0 -> negative.
    expect_equal(
        make_polarity(scores, threshold = 0),
        c("negative", "negative", "neutral", "positive", "positive")
    )

    # Threshold = 0.8
    # pos=0.8, neg=-0.8
    # 0.5 < 0.8 and > -0.8 -> neutral
    expect_equal(
        make_polarity(scores, threshold = 0.8),
        c("negative", "neutral", "neutral", "neutral", "positive")
    )
})

test_that("make_polarity works with asymmetric thresholds", {
    # Using clearly asymmetric thresholds: strict positive (0.8), lenient negative (-0.1)
    scores <- c(0.9, 0.5, 0, -0.05, -0.2)

    # Threshold = c(0.8, -0.1)
    # 0.9 >= 0.8 -> positive
    # 0.5 < 0.8 (and > -0.1) -> neutral (would be positive if symmetric 0.1, or neutral if symmetric 0.8)
    # 0 -> neutral
    # -0.05 > -0.1 -> neutral (would be negative if symmetric 0.05)
    # -0.2 <= -0.1 -> negative

    expected <- c("positive", "neutral", "neutral", "neutral", "negative")

    expect_equal(
        make_polarity(scores, threshold = c(0.8, -0.1)),
        expected
    )

    # Order should not matter: c(-0.1, 0.8) behaves identical to c(0.8, -0.1)
    expect_equal(
        make_polarity(scores, threshold = c(-0.1, 0.8)),
        expected
    )
})

test_that("make_polarity handles errors correctly", {
    expect_error(make_polarity(1, threshold = -1), "positive value")
    expect_error(make_polarity(1, threshold = c(1, 2)), "one positive.*one negative")
    expect_error(make_polarity(1, threshold = c(-1, -2)), "one positive.*one negative")
    expect_error(make_polarity("a"), "numeric")
})
