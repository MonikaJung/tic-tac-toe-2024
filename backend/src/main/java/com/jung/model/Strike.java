package com.jung.model;

public enum Strike {
    ROW1("strike-row-1"),
    ROW2("strike-row-2"),
    ROW3("strike-row-3"),
    COL1("strike-column-1"),
    COL2("strike-column-2"),
    COL3("strike-column-3"),
    DIA1("strike-diagonal-1"),
    DIA2("strike-diagonal-2");

    private final String cssClass;

    Strike(String cssClass) {
        this.cssClass = cssClass;
    }

    public String getCssClass() {
        return cssClass;
    }
}
