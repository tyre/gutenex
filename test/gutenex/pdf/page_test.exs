defmodule Gutenex.PDF.PageTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Page

  test "#to_pdf with no options should build the object" do
    expected =
      {:dict,
       [{"Type", {:name, "Page"}}, {"Parent", {:ptr, 5, 3}}, {"Contents", {:ptr, 1_000, 3}}]}

    assert Page.to_pdf(5, 1_000, 3) == expected
  end

  test "#to_pdf with options should translate them to strings" do
    options = %{last_modified: {{2014, 1, 31}, {15, 15, 00}}}
    generation_number = 7

    expected =
      {:dict,
       [
         {"Type", {:name, "Page"}},
         {"Parent", {:ptr, 5, generation_number}},
         {"Contents", {:ptr, 1_000, generation_number}},
         {"LastModified", {:date, options[:last_modified]}}
       ]}

    assert Page.to_pdf(5, 1_000, generation_number, options) == expected
  end

  test "#page_size with arbitrary width and height" do
    assert Page.page_size(29_999, 38_792) == {0, 0, 29_999, 38_792}
  end

  test "#page_size :a0" do
    assert Page.page_size(:a0) == {0, 0, 2380, 3368}
  end

  test "#page_size :a1" do
    assert Page.page_size(:a1) == {0, 0, 1684, 2380}
  end

  test "#page_size :a2" do
    assert Page.page_size(:a2) == {0, 0, 1190, 1684}
  end

  test "#page_size :a3" do
    assert Page.page_size(:a3) == {0, 0, 842, 1190}
  end

  test "#page_size :a4" do
    assert Page.page_size(:a4) == {0, 0, 595, 842}
  end

  test "#page_size :a5" do
    assert Page.page_size(:a5) == {0, 0, 421, 595}
  end

  test "#page_size :a6" do
    assert Page.page_size(:a6) == {0, 0, 297, 421}
  end

  test "#page_size :a7" do
    assert Page.page_size(:a7) == {0, 0, 210, 297}
  end

  test "#page_size :a8" do
    assert Page.page_size(:a8) == {0, 0, 148, 210}
  end

  test "#page_size :a9" do
    assert Page.page_size(:a9) == {0, 0, 105, 148}
  end

  test "#page_size :b0" do
    assert Page.page_size(:b0) == {0, 0, 2836, 4008}
  end

  test "#page_size :b1" do
    assert Page.page_size(:b1) == {0, 0, 2004, 2836}
  end

  test "#page_size :b2" do
    assert Page.page_size(:b2) == {0, 0, 1418, 2004}
  end

  test "#page_size :b3" do
    assert Page.page_size(:b3) == {0, 0, 1002, 1418}
  end

  test "#page_size :b4" do
    assert Page.page_size(:b4) == {0, 0, 709, 1002}
  end

  test "#page_size :b5" do
    assert Page.page_size(:b5) == {0, 0, 501, 709}
  end

  test "#page_size :b6" do
    assert Page.page_size(:b6) == {0, 0, 355, 501}
  end

  test "#page_size :b7" do
    assert Page.page_size(:b7) == {0, 0, 250, 355}
  end

  test "#page_size :b8" do
    assert Page.page_size(:b8) == {0, 0, 178, 250}
  end

  test "#page_size :b9" do
    assert Page.page_size(:b9) == {0, 0, 125, 178}
  end

  test "#page_size :b10" do
    assert Page.page_size(:b10) == {0, 0, 89, 125}
  end

  test "#page_size :c5e" do
    assert Page.page_size(:c5e) == {0, 0, 462, 649}
  end

  test "#page_size :comm10e" do
    assert Page.page_size(:comm10e) == {0, 0, 298, 683}
  end

  test "#page_size :dle" do
    assert Page.page_size(:dle) == {0, 0, 312, 624}
  end

  test "#page_size :executive" do
    assert Page.page_size(:executive) == {0, 0, 542, 720}
  end

  test "#page_size :folio" do
    assert Page.page_size(:folio) == {0, 0, 595, 935}
  end

  test "#page_size :ledger" do
    assert Page.page_size(:ledger) == {0, 0, 1224, 792}
  end

  test "#page_size :legal" do
    assert Page.page_size(:legal) == {0, 0, 612, 1008}
  end

  test "#page_size :letter" do
    assert Page.page_size(:letter) == {0, 0, 612, 792}
  end

  test "#page_size :tabloid" do
    assert Page.page_size(:tabloid) == {0, 0, 792, 1224}
  end
end
