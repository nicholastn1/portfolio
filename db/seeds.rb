puts "Seeding database..."

# Admin user
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@nicholasnogueira.dev")
admin_password = ENV["ADMIN_PASSWORD"].presence ||
  (Rails.env.production? ? raise("ADMIN_PASSWORD env var is required in production") : "changeme123")
admin = User.find_or_create_by!(email: admin_email) do |u|
  u.name = "Nicholas Nogueira"
  u.password = admin_password
end
puts "  Admin user: #{admin.email}"

# Personal Info
info = PersonalInfo.find_or_initialize_by(email: "nicholastimbo2022@gmail.com")
info.update!(
  name: "Nicholas Nogueira",
  title: "Software Engineer",
  location: "Fortaleza, Ceará, Brasil",
  phone: "+5585997041828",
  whatsapp_message: "Olá. Tive interesse em seu perfil. Podemos marcar uma conversa?",
  bio_pt: [
    "Sou um Engenheiro de Software com mais de 5 anos de experiência em diversas indústrias como fintechs, e-commerces, igrejas tech e govtechs. Minhas principais tecnologias incluem Ruby, Rails, Docker, PostgreSQL e Sidekiq. Meus colegas costumam me descrever como um pensador inovador e pragmático que testa ideias da perspectiva do usuário, e como um solucionador de problemas confiável que colabora em equipes multifuncionais de ritmo acelerado.",
    "Na Intersol, iniciei minha carreira desenvolvendo soluções web para administração pública. Implementei funcionalidades-chave para o módulo contábil do sistema, aumentando em 100% a consistência dos fluxos, e otimizei o processo de licitações resultando em 40% de aumento na velocidade para clientes de múltiplos municípios.",
    "No FitBank, participei do programa de liderança trabalhando no desenvolvimento de sistemas e otimização de processos, com foco na aplicação de princípios SOLID e Clean Architecture. Reduzi em ~40% a complexidade do backend e melhorei em ~30% a performance do sistema administrativo interno utilizando .NET, C# e ReactJS.",
    "Na inChurch/Atos6, trabalhei como Software Engineer focado em melhorar a performance e a segurança do sistema. Reduzi em ~70% alterações não autorizadas implementando algoritmos lambda, diminuí em ~40% o tempo de resposta da aplicação (de 24.3s para 14.8s) otimizando queries N+1 e implementando estratégias de caching com Redis. Também aumentei em ~20% a produtividade das equipes através da reestruturação do pipeline de desenvolvimento.",
    "Atualmente sou Software Engineer na Gocase, onde implemento soluções para otimizar processos operacionais de e-commerce. Destaco a redução de 80% no tempo de coleta de pedidos (de 10 para 2 minutos) desenvolvendo um fluxo de picking em ondas com otimização de rotas, aumento de ~20% no NPS através da reformulação do sistema de atendimento ao cliente com Vue.js e ferramentas de IA, e prevenção de ~99% na criação de pedidos duplicados implementando um sistema de referência baseado em SHA-256."
  ],
  bio_en: [
    "I'm a Software Engineer with 5+ years of experience across diverse industries including fintechs, e-commerce, church tech, and govtechs. My core technologies include Ruby, Rails, Docker, PostgreSQL, and Sidekiq. Colleagues describe me as an innovative and pragmatic thinker who tests ideas from the user's perspective, and as a reliable problem-solver who collaborates in fast-paced cross-functional teams.",
    "At Intersol, I started my career developing web solutions for public administration. I implemented key features for the accounting module, achieving 100% flow consistency, and streamlined the bidding process resulting in a 40% speed increase for clients across multiple municipalities.",
    "At FitBank, I participated in a leadership program working on system development and process optimization, focusing on applying SOLID and Clean Architecture principles. I reduced backend complexity by ~40% and improved internal admin system performance by ~30% using .NET, C#, and ReactJS.",
    "At inChurch/Atos6, I worked as a Software Engineer focused on improving system performance and security. I reduced unauthorized changes by ~70% through implementing lambda algorithms, decreased application response time by ~40% (from 24.3s to 14.8s) by optimizing N+1 queries and implementing Redis caching strategies. I also increased team productivity by ~20% through development pipeline restructuring.",
    "Currently, I'm a Software Engineer at Gocase, where I implement solutions to optimize e-commerce operational processes. Key achievements include 80% reduction in order picking time (from 10 to 2 minutes) by developing a wave-based picking flow with route optimization, ~20% NPS increase through customer service system redesign with Vue.js and AI tools, and ~99% prevention of duplicate order creation by implementing a SHA-256-based reference system."
  ],
  footer_text_pt: "Se você tem interesse em meu perfil, me envie uma mensagem no whatsapp para conversarmos. Estou aberto a novas oportunidades, especialmente em projetos focados em otimização, arquitetura de sistemas e exploração do potencial da IA no desenvolvimento de software!",
  footer_text_en: "If you're interested in my profile, send me a message on whatsapp so we can chat. I'm open to new opportunities, especially in projects focused on optimization, system architecture, and exploring AI's potential in software development!"
)
puts "  Personal info created"

# Social Links
[
  { platform: "github", url: "https://github.com/nicholastn1", label: "GitHub", icon: "github", position: 1 },
  { platform: "linkedin", url: "https://www.linkedin.com/in/nicholastn/", label: "LinkedIn", icon: "linkedin", position: 2 },
  { platform: "instagram", url: "https://www.instagram.com/nicholastn_/", label: "Instagram", icon: "instagram", position: 3 },
  { platform: "whatsapp", url: "https://api.whatsapp.com/send/?phone=5585997041828&text=Ol%C3%A1.%20Tive%20interesse%20em%20seu%20perfil.%20Podemos%20marcar%20uma%20conversa%3F&app_absent=0", label: "WhatsApp", icon: "whatsapp", position: 4 },
  { platform: "email", url: "mailto:nicholastimbo2022@gmail.com", label: "Email", icon: "email", position: 5 }
].each do |attrs|
  info.social_links.find_or_create_by!(platform: attrs[:platform]) do |sl|
    sl.assign_attributes(attrs)
  end
end
puts "  Social links created"

# Experiences
[
  {
    company: "Gocase",
    role_pt: "Software Engineer | Full Stack",
    role_en: "Software Engineer | Full Stack",
    company_url: "https://www.gocase.com.br",
    started_at: Date.new(2024, 5, 1),
    ended_at: nil,
    description_pt: "Empresa de e-commerce que permite aos clientes se expressarem através de capinhas personalizadas, garrafas térmicas e mais.",
    description_en: "E-commerce company that allows customers to express themselves through customized phone cases, thermal bottles, and more.",
    achievements_pt: [
      "Integração de serviço de análise de crédito automatizando scoring de risco e decisões de pagamento, reduzindo análise manual em 60h/mês (R$ 2.280) e checks da Serasa em 40/mês (R$ 737)",
      "Redução de ~20% no tempo de code review implementando um agente de IA para revisão de PR/MR via CI/CD",
      "Redução de 80% no tempo de coleta de pedidos (de 10 para 2 minutos) desenvolvendo um sistema de coleta em lote com Ruby on Rails e PostgreSQL",
      "Redução de 99%+ no tempo de setup do ambiente de desenvolvimento (de 3 dias para 20 minutos) dockerizando dois sistemas monolíticos legados",
      "Redução de 15 minutos por pedido na carga operacional dos vendedores através de automação de fluxo de segmentação de pedidos no monolito B2B",
      "Prevenção de ~99,9% na criação de pedidos duplicados implementando sistema de referência baseado em SHA-256, economizando estimados $1.850+ anuais"
    ],
    achievements_en: [
      "Integrated credit analysis service into the Rails application, automating risk scoring and payment decisions; reduced manual analysis by 60h/month (R$ 2,280) and Serasa checks by 40/month (R$ 737)",
      "Reduced by ~20% the code review time by implementing a PR/MR reviewer AI agent using CI/CD",
      "Decreased order collection time by 80%, from 10 to 2 minutes per order, by developing a bulk collection system that optimized distribution center processes using Ruby on Rails and PostgreSQL",
      "Lowered development environment setup time by over 99%, from 3 days to 20 minutes, by Dockerizing two legacy monolithic systems using Docker, Makefiles, and ShellScript",
      "Lessened sellers' operational workload by 15 minutes per order by engineering an automated order segmentation flow within the B2B Ruby on Rails monolith and invoicing systems",
      "Prevented over 99.9% of duplicate order creations by implementing a robust SHA256 hash-based reference system in Ruby on Rails, saving an estimated $1,850+ annually"
    ],
    technologies: [ "Ruby on Rails", "Vue.js", "TypeScript", "PostgreSQL", "Redis", "Sidekiq", "Docker", "OpenAI API" ],
    position: 1
  },
  {
    company: "inChurch/Atos6",
    role_pt: "Software Engineer | Back-end",
    role_en: "Software Engineer | Back-end",
    company_url: "https://inchurch.com.br",
    started_at: Date.new(2022, 10, 1),
    ended_at: Date.new(2024, 5, 1),
    description_pt: "Plataforma de gestão integrada utilizada por mais de 4.000 igrejas, fornecendo soluções para apoiar o dia a dia das congregações.",
    description_en: "Integrated management platform used by over 4,000 churches, providing solutions to support congregations' daily operations.",
    achievements_pt: [
      "Redução de ~70% em alterações não autorizadas e diminuição de ajustes manuais implementando algoritmos lambda em Ruby on Rails",
      "Redução de ~40% no tempo de resposta da aplicação (de 24.3s para 14.8s) otimizando queries N+1, implementando caching com Redis e integrando CDNs",
      "Aumento de ~20% na produtividade das equipes através da reestruturação do pipeline de desenvolvimento (CI/CD) e adoção de metodologias ágeis",
      "Redução de ~40% nas reclamações de clientes resolvendo bugs do sistema alinhados com princípios ágeis e SLAs"
    ],
    achievements_en: [
      "Achieved a 70% drop in unauthorized alterations and slashed manual adjustment efforts by 30% by implementing lambda algorithms in Ruby on Rails while redesigning database schema and permissions architecture",
      "Reduced application response time by 76% (from +60ms to ~14ms) by identifying and optimizing N+1 queries with bullet gem, overhauling the MVC structure, and integrating CDNs and micro-frontends",
      "Boosted support and development team delivery performance by 20% through active involvement in restructuring the development pipeline, incorporating Kanban and software engineering principles",
      "Reduced more than 40% of customer complaints by resolving system bugs, achieving a 100% validation rate for fixes"
    ],
    technologies: [ "Ruby on Rails", "GraphQL", "Redis", "Microsserviços", "CI/CD", "Jira", "Basecamp" ],
    position: 2
  },
  {
    company: "FitBank",
    role_pt: "Software Developer | Full Stack",
    role_en: "Software Developer | Full Stack",
    company_url: "https://fitbank.com.br",
    started_at: Date.new(2021, 9, 1),
    ended_at: Date.new(2022, 10, 1),
    description_pt: "Única plataforma brasileira 100% cloud-native integrada ao Sistema de Pagamentos Brasileiro (SPB).",
    description_en: "The only Brazilian 100% cloud-native platform integrated with the Brazilian Payment System (SPB).",
    achievements_pt: [
      "Redução de ~40% na complexidade do backend simplificando o processo de desenvolvimento através da aplicação de princípios SOLID e Clean Architecture",
      "Melhoria de ~30% na performance de processos administrativos internos recriando o sistema interno com .NET, C# e ReactJS"
    ],
    achievements_en: [
      "Reduced system complexity and maintenance difficulties by 40% by simplifying the development process alongside the Software Architects team through the utilization of SOLID and Clean Architecture principles",
      "Enabled processes to be performed more quickly through the recreation of the internal administrative system, resulting in a performance improvement of approximately 30% compared to the old system"
    ],
    technologies: [ "C#", ".NET", "ReactJS", "Redux", "SQL Server", "Azure DevOps", "SOLID", "Clean Architecture", "Microservices" ],
    position: 3
  },
  {
    company: "Intersol",
    role_pt: "Software Developer | Back-end",
    role_en: "Software Developer | Back-end",
    company_url: nil,
    started_at: Date.new(2020, 12, 1),
    ended_at: Date.new(2021, 9, 1),
    description_pt: "Empresa especializada em soluções web para administração pública.",
    description_en: "Company specialized in web solutions for public administration.",
    achievements_pt: [
      "Aumento de 100% na consistência de fluxo implementando funcionalidades-chave no módulo de contabilidade, incluindo sistema de controle de revisão",
      "Melhoria de ~40% na velocidade do processo de licitação otimizando o fluxo de criação para clientes de múltiplos municípios"
    ],
    achievements_en: [
      "Increased a 100% in flow consistency by implementing key features for the accounting module of the system, such as a review control system that mitigated possible bypasses",
      "Streamlined the bidding process with a simplified creation flow, resulting in a 40% increase in speed for clients in multiple municipalities"
    ],
    technologies: [ "Ruby on Rails", "PostgreSQL", "HTML", "CSS", "JavaScript", "Git" ],
    position: 4
  }
].each do |attrs|
  Experience.find_or_create_by!(company: attrs[:company], started_at: attrs[:started_at]) do |e|
    e.assign_attributes(attrs)
  end
end
puts "  #{Experience.count} experiences created"

# Education
Education.find_or_create_by!(institution: "Centro Universitário Farias Brito") do |e|
  e.assign_attributes(
    degree_pt: "Bacharelando",
    degree_en: "Bachelor's (In Progress)",
    course_pt: "Ciência da Computação",
    course_en: "Computer Science",
    started_at: Date.new(2020, 1, 1),
    ended_at: nil,
    activities_pt: [ "Membro do Centro Acadêmico (AC)", "Assessor de Projetos (2022-2023)" ],
    activities_en: [ "Academic Center (AC) member", "Projects Advisor (2022-2023)" ],
    position: 1
  )
end
puts "  #{Education.count} education records created"

# Certifications
[
  { name_pt: "UI Design for Beginners", name_en: "UI Design for Beginners", provider: "Origamid", certified_at: Date.new(2023, 4, 1), position: 1 },
  { name_pt: "Ruby Developer Training", name_en: "Ruby Developer Training", provider: "DIO", certified_at: Date.new(2023, 2, 1), position: 2 },
  { name_pt: "Potencial .NET Developer", name_en: "Potential .NET Developer", provider: "DIO", certified_at: Date.new(2022, 9, 1), position: 3 },
  { name_pt: "React Developer Training", name_en: "React Developer Training", provider: "DIO", certified_at: Date.new(2022, 9, 1), position: 4 },
  { name_pt: "Cyber Security Experience II", name_en: "Cyber Security Experience II", provider: "XP Educação", certified_at: Date.new(2022, 7, 1), position: 5 },
  { name_pt: "Formação .NET Developer", name_en: ".NET Developer Training", provider: "DIO", certified_at: Date.new(2022, 7, 1), position: 6 },
  { name_pt: "Fundamentos do Git e Azure DevOps", name_en: "Git and Azure DevOps Fundamentals", provider: "balta.io", certified_at: Date.new(2022, 7, 1), position: 7 },
  { name_pt: "Introdução à Ciência da Computação - O Curso de Harvard", name_en: "Introduction to Computer Science - Harvard's Course", provider: "Fundação Estudar", certified_at: Date.new(2022, 7, 1), position: 8 },
  { name_pt: "EF SET English Certificate (B2 Upper Intermediate)", name_en: "EF SET English Certificate (B2 Upper Intermediate)", provider: "EF SET", certified_at: Date.new(2022, 4, 1), position: 9 }
].each do |attrs|
  Certification.find_or_create_by!(name_pt: attrs[:name_pt], provider: attrs[:provider]) do |c|
    c.assign_attributes(attrs)
  end
end
puts "  #{Certification.count} certifications created"

# Volunteering
[
  { role_pt: "Monitor", role_en: "Monitor", organization: "Fundação Estudar", started_at: Date.new(2022, 2, 1), ended_at: Date.new(2023, 1, 1), position: 1 },
  { role_pt: "DIO Campus Expert Ambassador #6", role_en: "DIO Campus Expert Ambassador #6", organization: "DIO", started_at: Date.new(2023, 2, 1), ended_at: Date.new(2023, 4, 1), position: 2 },
  { role_pt: "DIO Campus Expert Ambassador #4", role_en: "DIO Campus Expert Ambassador #4", organization: "DIO", started_at: Date.new(2022, 7, 1), ended_at: Date.new(2022, 9, 1), position: 3 }
].each do |attrs|
  Volunteering.find_or_create_by!(role_pt: attrs[:role_pt], organization: attrs[:organization]) do |v|
    v.assign_attributes(attrs)
  end
end
puts "  #{Volunteering.count} volunteering records created"

# Projects
[
  {
    name: "Nebula Jobs",
    description_pt: "Plataforma para busca de vagas de tecnologia e gerenciamento de candidaturas com acompanhamento inteligente. Possui Kanban com drag & drop, geração de currículos personalizados por vaga usando IA (GPT-4), scraping automático de vagas, e suporte a internacionalização (PT-BR/EN-US).",
    description_en: "Platform for searching tech jobs and managing applications with intelligent tracking. Features a Kanban board with drag & drop, AI-powered tailored CV generation (GPT-4), automatic job scraping, and internationalization support (PT-BR/EN-US).",
    started_at: Date.new(2025, 12, 1),
    ended_at: nil,
    technologies: [ "Next.js", "NestJS", "TypeScript", "PostgreSQL", "Prisma", "Redis", "OpenAI API", "Fly.io" ],
    github_url: "https://github.com/nicholastn1/nebula-frontend",
    position: 1
  },
  {
    name: "Home Lab",
    description_pt: "Projeto de infraestrutura pessoal criado a partir de um notebook antigo. Inicialmente usado como ambiente de estudo para Kubernetes, IaC, redes e automação. Hoje roda Proxmox com uma VM Coolify e PCI passthrough de GPU para executar modelos de LLM como Whisper e Ollama em projetos pessoais de conversação.",
    description_en: "Personal infrastructure project built from an old laptop that was gathering dust. Initially used as a learning environment for Kubernetes, IaC, networking, and automation. Now runs Proxmox with a Coolify VM and GPU PCI passthrough for running LLM models like Whisper and Ollama in personal conversation projects.",
    started_at: Date.new(2025, 1, 1),
    ended_at: nil,
    technologies: [ "Proxmox", "Coolify", "Docker", "Kubernetes", "IaC", "LLM", "Whisper", "Ollama" ],
    github_url: "https://github.com/nicholastn1/coolify-backup",
    position: 2
  },
  {
    name: "GymGenius",
    description_pt: "GymGenius é um projeto que busca resolver um problema pessoal, mas que pode ser aplicado para qualquer pessoa com necessidade similar. O objetivo é permitir que o usuário gerencie e organize seu treino de musculação de forma personalizada, evitando soluções pagas e frequentemente superficiais.",
    description_en: "GymGenius is a project that aims to solve a personal problem but can be applied to anyone with similar needs. The goal is to allow users to manage and organize their workout routine in a personalized way, avoiding paid solutions that are often superficial.",
    started_at: Date.new(2023, 5, 1),
    ended_at: nil,
    technologies: [ "Ruby", "React.js", "AI", "OpenAI API", "AWS", "MCP" ],
    github_url: "https://github.com/nicholastn1/gymgeniusweb",
    position: 3
  },
  {
    name: "Portfólio",
    description_pt: "Projeto de portfólio pessoal criado para demonstrar meus conhecimentos e apresentar um pouco das minhas características e curiosidades, bem como informações profissionais e habilidades.",
    description_en: "Personal portfolio project created to showcase my knowledge and present some of my characteristics and interests, as well as professional information and skills.",
    started_at: Date.new(2022, 5, 1),
    ended_at: nil,
    technologies: [ "Ruby on Rails", "Phlex", "Tailwind CSS", "SQLite", "Hotwire" ],
    github_url: "https://github.com/nicholastn1/nicholastn1.github.io",
    url: "https://nicholastn1.github.io",
    position: 4
  }
].each do |attrs|
  Project.find_or_create_by!(name: attrs[:name]) do |p|
    p.assign_attributes(attrs)
  end
end
puts "  #{Project.count} projects created"

# Skills
pos = 0
{
  proficient: [
    { name: "Ruby", category: "backend", featured: true },
    { name: "Rails", category: "backend", featured: true },
    { name: "Sidekiq", category: "backend", featured: false },
    { name: "Docker", category: "devops", featured: true },
    { name: "Nuxt", category: "frontend", featured: false },
    { name: "Vue", category: "frontend", featured: true },
    { name: "JavaScript", category: "frontend", featured: false },
    { name: "jQuery", category: "frontend", featured: false },
    { name: "SQL", category: "database", featured: false },
    { name: "PostgreSQL", category: "database", featured: true },
    { name: "Bootstrap", category: "frontend", featured: false },
    { name: "Git", category: "devops", featured: false },
    { name: "Bash", category: "devops", featured: false },
    { name: "Linux", category: "devops", featured: false },
    { name: "REST API", category: "backend", featured: true },
    { name: "Heroku", category: "devops", featured: false },
    { name: "Microservices", category: "architecture", featured: true },
    { name: "Scrum", category: "methodology", featured: false },
    { name: "Kanban", category: "methodology", featured: false }
  ],
  intermediate: [
    { name: "AWS", category: "cloud", featured: false },
    { name: "Amazon S3", category: "cloud", featured: false },
    { name: "ReactJS", category: "frontend", featured: false },
    { name: "Redux", category: "frontend", featured: false },
    { name: "Redis", category: "database", featured: false },
    { name: "C#", category: "backend", featured: true },
    { name: ".NET", category: "backend", featured: false },
    { name: "TypeScript", category: "frontend", featured: true },
    { name: "GraphQL", category: "backend", featured: false },
    { name: "Swagger", category: "documentation", featured: false },
    { name: "Grafana", category: "devops", featured: false },
    { name: "Kubernetes", category: "devops", featured: false },
    { name: "UI/UX", category: "design", featured: false }
  ],
  beginner: [
    { name: "Django", category: "backend", featured: false },
    { name: "Python", category: "backend", featured: false },
    { name: "Elixir", category: "backend", featured: false },
    { name: "NestJS", category: "backend", featured: false },
    { name: "Angular", category: "frontend", featured: false },
    { name: "SQL Server", category: "database", featured: false }
  ]
}.each do |proficiency, skills|
  skills.each do |attrs|
    pos += 1
    Skill.find_or_create_by!(name: attrs[:name]) do |s|
      s.assign_attributes(attrs.merge(proficiency: proficiency.to_s, position: pos))
    end
  end
end
puts "  #{Skill.count} skills created (#{Skill.featured.count} featured)"

# Languages
[
  { name_pt: "Português", name_en: "Portuguese", level_pt: "Nativo", level_en: "Native", proficiency: "native", position: 1 },
  { name_pt: "Inglês", name_en: "English", level_pt: "Avançado (C1)", level_en: "Advanced (C1)", proficiency: "advanced", position: 2 },
  { name_pt: "Espanhol", name_en: "Spanish", level_pt: "Básico", level_en: "Basic", proficiency: "basic", position: 3 }
].each do |attrs|
  Language.find_or_create_by!(name_pt: attrs[:name_pt]) do |l|
    l.assign_attributes(attrs)
  end
end
puts "  #{Language.count} languages created"

puts "\nSeed complete!"
