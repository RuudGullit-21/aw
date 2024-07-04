////////////////////////////////////////////////////////////////////////////////
// Управление автотранспортом.
// 
// Процедуры и функции общего назначения, перенесенные из типовых конфигураций.
// 
// Содержит код, используемый в варианте поставке ПРОФ, КОРП
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Функция - Типы подключенного оборудования
// 
// Возвращаемое значение:
//   - 
//
Функция ТипыПодключенногоОборудования() Экспорт
	
	Возврат МенеджерОборудованияВызовСервера.ТипыИспользуемогоОборудованияТекущегоРабочегоМеста();
	
КонецФункции // ТипыПодключенногоОборудования()

// Функция - Уат использовать учет билетов и выручки
// 
// Возвращаемое значение:
//   - 
//
Функция уатИспользоватьУчетБилетовИВыручки() Экспорт
	
	Возврат Константы.уатИспользоватьУчетБилетовИВыручки.Получить();
	
КонецФункции // уатИспользоватьУчетБилетовИВыручки()

// Функция - Полное наименование адресного сокращения
//
// Параметры:
//  АдресноеСокращение	 - 	 - 
//  Уровень				 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПолноеНаименованиеАдресногоСокращения(АдресноеСокращение, Уровень = Неопределено) Экспорт
	
	Возврат АдресныйКлассификатор.ПолноеНаименованиеАдресногоСокращения(АдресноеСокращение, Уровень);
	
КонецФункции // ПолноеНаименованиеАдресногоСокращения();

// Функция - Получить тип используемых электронных карт
//
// Параметры:
//  ТипПоставщика	 - Строка - строка вида "Картография", "Геокодирование", "ПостроениеМаршрутов",
//                              "Навигация" или "Маршрутизация"
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьТипИспользуемыхЭлектронныхКарт(ТипПоставщика = "Картография") Экспорт
	
	Если НЕ Константы.уатИспользоватьЭлектронныеКарты.Получить() Тогда
		Возврат Перечисления.уатТипыЭлектронныхКарт.ПустаяСсылка();
	КонецЕсли;
	
	ЗначениеНастройки = уатЭлектронныеКартыСервер.ПолучитьНастройкуСервераКартографииМаршрутизации(ТипПоставщика + "_ТипПоставщика");
	Если ТипЗнч(ЗначениеНастройки) = Тип("ПеречислениеСсылка.уатТипыЭлектронныхКарт") Тогда 
		Возврат ЗначениеНастройки;
	Иначе 
		Возврат Перечисления.уатТипыЭлектронныхКарт.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции // ПолучитьТипИспользуемыхЭлектронныхКарт()

// Функция предназначена для получения настроек подключения к серверам картографии
// и маршрутизации.
//
Функция ПолучитьНастройкиСервераКартографииМаршрутизации() Экспорт
	
	СтруктураРезультат = уатЭлектронныеКартыСервер.НастройкиСервераКартографииМаршрутизацииПоУмолчанию();
	
	ХранилищеНастроек = Константы.уатСерверКартографииМаршрутизации.Получить();
	Если ХранилищеНастроек = Неопределено Тогда 
		Возврат СтруктураРезультат;
	КонецЕсли;
	СтруктураНастроек = ХранилищеНастроек.Получить();
	Если СтруктураНастроек = Неопределено Тогда 
		Возврат СтруктураРезультат;
	КонецЕсли;
	
	Для Каждого ТекНастройка Из СтруктураРезультат Цикл 
		Если СтруктураНастроек.Свойство(ТекНастройка.Ключ) Тогда
			СтруктураРезультат.Вставить(ТекНастройка.Ключ, СтруктураНастроек[ТекНастройка.Ключ]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции // ПолучитьТипИспользуемыхЭлектронныхКарт()

// Функция - Использовать характеристики заказов на ТС
// 
// Возвращаемое значение:
//   - 
//
Функция ИспользоватьХарактеристикиЗаказовНаТС() Экспорт
	
	Возврат Константы.уатИспользоватьХарактеристикиЗаказовНаТС_уэ.Получить();
	
КонецФункции // ИспользоватьХарактеристикиЗаказовНаТС()

// Функция - Получить настройки видов контактной информации
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьНастройкиВидовКонтактнойИнформации() Экспорт 
	
	стрРезультат = НастройкиВидовКонтактнойИнформацииПоУмолчанию();
	
	ХранилищеНастройки = Константы.уатНастройкиВидовКонтактнойИнформации.Получить();
	Если ХранилищеНастройки = Неопределено Тогда 
		Возврат стрРезультат;
	КонецЕсли;
	стрНастройки = ХранилищеНастройки.Получить();
	Если стрНастройки = Неопределено Тогда 
		Возврат стрРезультат;
	КонецЕсли;
	
	Для Каждого ТекНастройка Из стрРезультат Цикл 
		Если стрНастройки.Свойство(ТекНастройка.Ключ) Тогда
			стрРезультат.Вставить(ТекНастройка.Ключ, стрНастройки[ТекНастройка.Ключ]);
		Иначе 
			стрРезультат.Вставить(ТекНастройка.Ключ, НастройкиВидовКонтактнойИнформацииПоУмолчанию(ТекНастройка.Ключ));
		КонецЕсли;
	КонецЦикла;
	
	Возврат стрРезультат;
	
КонецФункции

// Функция - Получить настройки по умолчанию видов контактной информации
// 
// Возвращаемое значение:
//   - 
//
Функция НастройкиВидовКонтактнойИнформацииПоУмолчанию(ВыбранноеСвойство="") Экспорт 
	
	стрНастройки = Новый Структура();
	
	стрНастройки.Вставить("видКонтактнойИнформацииТелефонКонтрагента",     Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
	стрНастройки.Вставить("видКонтактнойИнформацииEmailКонтрагента",       Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты);
	стрНастройки.Вставить("видКонтактнойИнформацииТелефонКонтактногоЛица", Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйКонтактныеЛица);
	стрНастройки.Вставить("видКонтактнойИнформацииEmailКонтактногоЛица",   Справочники.ВидыКонтактнойИнформации.EmailКонтактныеЛица);
	стрНастройки.Вставить("видКонтактнойИнформацииТелефонПользователя",    Справочники.ВидыКонтактнойИнформации.ТелефонПользователя);
	стрНастройки.Вставить("видКонтактнойИнформацииEmailПользователя",      Справочники.ВидыКонтактнойИнформации.EmailПользователя);
	стрНастройки.Вставить("видКонтактнойИнформацииТелефонФизическогоЛица", Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица);
	стрНастройки.Вставить("видКонтактнойИнформацииEmailФизическогоЛица",   Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
	
	Если ВыбранноеСвойство = "" Тогда 
		Возврат стрНастройки;
	Иначе 
		Попытка
			Возврат стрНастройки[ВыбранноеСвойство];
		Исключение
			Возврат "";
		КонецПопытки;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПодсказкиПоАдресуDaData(Знач стрАдрес, ТекстОшибки= "") Экспорт
	Возврат уатЗащищенныеФункцииСервер_проф.ПолучитьПодсказкиПоАдресуDaData(стрАдрес, ТекстОшибки);
КонецФункции

#КонецОбласти