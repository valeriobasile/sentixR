test_that("sentix_summarize calculations are correct", {
    # Dummy data
    df <- data.frame(
        doc_id = c("doc1", "doc1", "doc2"),
        token = c("bello", "brutto", "neutro"),
        score = c(1, -1, 0),
        polypathy_index = c("0", "0", "0"),
        upos = c("ADJ", "ADJ", "NOUN"),
        stringsAsFactors = FALSE
    )

    res <- sentix_summarize(df, ambiguity = "none")

    # Doc1: mean(1, -1) = 0
    expect_equal(res$score[res$doc_id == "doc1"], 0)
    # Doc2: 0
    expect_equal(res$score[res$doc_id == "doc2"], 0)
})

test_that("sentix_summarize ambiguity logic", {
    df <- data.frame(
        doc_id = c("d1"),
        score = c(1, 1),
        polypathy_index = c("0", "2"), # 1 non-ambiguous, 1 ambiguous (>=1)
        upos = c("A", "B"),
        stringsAsFactors = FALSE
    )

    # Ambiguity = "1" -> tokens with index >=1 are ambiguous
    res <- sentix_summarize(df, ambiguity = "1", simplify = FALSE)

    # 2 scored tokens
    expect_equal(res$n_scored, 2)
    # 1 ambiguous token (index "2" >= "1")
    expect_equal(res$n_poly, 1)
    # Ambiguity = 1/2 = 0.5
    expect_equal(res$ambiguity, 0.5)
})

test_that("sentix_summarize handles multiple columns", {
    df <- data.frame(
        doc_id = "d1",
        s1 = 1,
        s2 = 2,
        stringsAsFactors = FALSE
    )
    res <- sentix_summarize(df) # auto detects numerics
    expect_true("s1" %in% names(res))
    expect_true("s2" %in% names(res))
})

test_that("sentix_summarize aggregation sum", {
    df <- data.frame(doc_id = "d1", s = c(1, 2), stringsAsFactors = FALSE)
    res <- sentix_summarize(df, aggregation = "sum")
    expect_equal(res$s, 3)
})
