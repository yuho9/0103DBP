package com.campusmatching.model.domain;

public class Tag {
    public static final String TYPE_POSITION = "POSITION";
    public static final String TYPE_SKILL = "SKILL";

    private Long tagId;
    private String name;
    private String tagType;

    public Tag() {}

    public Tag(Long tagId, String name) {
        this(tagId, name, null);
    }

    public Tag(Long tagId, String name, String tagType) {
        this.tagId = tagId;
        this.name = name;
        this.tagType = tagType;
    }

    public Long getTagId() { return tagId; }
    public void setTagId(Long tagId) { this.tagId = tagId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getTagType() { return tagType; }
    public void setTagType(String tagType) { this.tagType = tagType; }

    public boolean isPosition() { return TYPE_POSITION.equals(tagType); }

    @Override
    public String toString() {
        return "#" + name + "(" + tagId + ", " + tagType + ")";
    }
}
