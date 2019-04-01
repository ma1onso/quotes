project('com.github.alonsoenrique.quotes','vala', 'c', version: '4.0.0')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()),
    language:'c'
)

asresources = gnome.compile_resources(
    'as-resources', 'data/style.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')
subdir('po')
subdir('data')

executable(
    meson.project_name(),
    sources,
    asresources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('granite')
    ],
    install: true
)