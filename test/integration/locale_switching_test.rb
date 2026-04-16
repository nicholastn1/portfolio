require "test_helper"

class LocaleSwitchingTest < ActionDispatch::IntegrationTest
  setup do
    @personal_info = PersonalInfo.create!(
      name: "Test User",
      title: "Developer",
      email: "test@example.com",
      location: "Test City",
      bio_pt: ["Bio em portugues"],
      bio_en: ["Bio in English"],
      footer_text_pt: "Texto do rodape em portugues",
      footer_text_en: "Footer text in English"
    )

    @experience = Experience.create!(
      company: "Test Corp",
      role_pt: "Engenheiro de Software",
      role_en: "Software Engineer",
      description_pt: "Descricao em portugues",
      description_en: "Description in English",
      achievements_pt: ["Conquista em portugues"],
      achievements_en: ["Achievement in English"],
      started_at: Date.new(2023, 1, 1),
      position: 1
    )

    @education = Education.create!(
      institution: "Test University",
      degree_pt: "Bacharelado",
      degree_en: "Bachelor's",
      course_pt: "Ciencia da Computacao",
      course_en: "Computer Science",
      started_at: Date.new(2020, 1, 1),
      position: 1
    )

    @certification = Certification.create!(
      name_pt: "Certificacao de Teste",
      name_en: "Test Certification",
      provider: "Test Provider",
      certified_at: Date.new(2023, 6, 1),
      position: 1
    )

    @volunteering = Volunteering.create!(
      role_pt: "Voluntario de Teste",
      role_en: "Test Volunteer",
      organization: "Test Org",
      started_at: Date.new(2022, 1, 1),
      position: 1
    )

    @language = Language.create!(
      name_pt: "Ingles",
      name_en: "English",
      level_pt: "Avancado",
      level_en: "Advanced",
      proficiency: "advanced",
      position: 1
    )
  end

  test "should display English content when visiting /en" do
    # First, verify Portuguese content on root
    get "/"
    assert_response :success
    assert_includes response.body, "Engenheiro de Software",
      "Portuguese role should appear on root path"

    # Now visit English path
    get "/en"
    assert_response :success

    # The page should display English content, not Portuguese
    assert_includes response.body, "Software Engineer",
      "English role should appear when visiting /en"
    # Note: meta description in layout still contains hardcoded Portuguese text,
    # so we check the experience section specifically
    assert_no_match(/text-accent-green font-medium.*Engenheiro de Software/m, response.body,
      "Portuguese role should NOT appear in experience section when visiting /en")
  end

  test "should display English bio when visiting /en" do
    get "/en"
    assert_response :success

    assert_includes response.body, "Bio in English",
      "English bio should appear when visiting /en"
    refute_includes response.body, "Bio em portugues",
      "Portuguese bio should NOT appear when visiting /en"
  end

  test "should display English education fields when visiting /en" do
    get "/en"
    assert_response :success

    assert_match(/Bachelor/, response.body,
      "English degree should appear when visiting /en")
    assert_includes response.body, "Computer Science",
      "English course should appear when visiting /en"
  end

  test "should display English certification name when visiting /en" do
    get "/en"
    assert_response :success

    assert_includes response.body, "Test Certification",
      "English certification name should appear when visiting /en"
    refute_includes response.body, "Certificacao de Teste",
      "Portuguese certification name should NOT appear when visiting /en"
  end

  test "should display English footer text when visiting /en" do
    get "/en"
    assert_response :success

    assert_includes response.body, "Footer text in English",
      "English footer text should appear when visiting /en"
    refute_includes response.body, "Texto do rodape em portugues",
      "Portuguese footer text should NOT appear when visiting /en"
  end

  test "should set locale to English via cookie and return English content" do
    get "/en"
    assert_response :success

    # Verify the locale cookie is set
    assert_equal "en", cookies[:locale],
      "Locale cookie should be set to 'en' after visiting /en"
  end

  test "should display Portuguese content on root path by default" do
    get "/"
    assert_response :success

    assert_includes response.body, "Engenheiro de Software",
      "Portuguese role should appear on root path"
    assert_includes response.body, "Bio em portugues",
      "Portuguese bio should appear on root path"
  end
end
