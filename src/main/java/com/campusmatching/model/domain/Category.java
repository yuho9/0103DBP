package com.campusmatching.model.domain;

public class Category {
    private Long categoryId;
    private Long parentId;
    private String name;

    public Category() {}

    public Category(Long categoryId, Long parentId, String name) {
        this.categoryId = categoryId;
        this.parentId = parentId;
        this.name = name;
    }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    @Override
    public String toString() {
        return "Category [categoryId=" + categoryId + ", parentId=" + parentId + ", name=" + name + "]";
    }
}
