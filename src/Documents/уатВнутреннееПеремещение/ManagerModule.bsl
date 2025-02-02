#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатВнутреннееПеремещение";
	КомандаПечати.Идентификатор = "СборочныйЛист";
	КомандаПечати.Представление = НСтр("en='Inner movement';ru='Сборочный лист'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents ""Inner movement""';ru='Реестр документов ""Внутреннее перемещение""'");
	КомандаПечати.Обработчик     = "уатОбщегоНазначенияТиповыеКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
	// Печать этикеток
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Этикетки";
	КомандаПечати.Представление = НСтр("ru = 'Этикетки'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru='Печать этикеток номенклатуры'");
	КомандаПечати.Обработчик = "уатОбщегоНазначенияТиповыеКлиент.ВыполнитьКомандуПечатиЭтикеток";
	КомандаПечати.МенеджерПечати = "";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 50;
		
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если НЕ уатОбщегоНазначенияСервер.РазрешениеПечатиНепроведенногоДокумента(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СборочныйЛист") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СборочныйЛист",
			"Сборочный лист", ПечатьВнутреннееПеремещение(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет переопределить ограничение, указанное в модуле менеджера объекта метаданных.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт

	ЗапросЯчейки = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаДокумента.Ссылка КАК Регистратор,
	|	ТаблицаДокумента.Ссылка.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке)
	|			ТОГДА ТаблицаДокумента.Ссылка.Склад.ТранзитнаяЯчейка
	|		ИНАЧЕ ТаблицаДокумента.ЯчейкаОтправитель
	|	КОНЕЦ КАК Ячейка,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Количество * ЕСТЬNULL(ТаблицаДокумента.ЕдиницаИзмерения.Коэффициент, 1) / ТаблицаДокумента.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Количество
	|ИЗ
	|	Документ.уатВнутреннееПеремещение.Товары КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаДокумента.Ссылка.Дата,
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.Ссылка.Склад,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки)
	|			ТОГДА ТаблицаДокумента.Ссылка.Склад.ТранзитнаяЯчейка
	|		ИНАЧЕ ТаблицаДокумента.ЯчейкаПолучатель
	|	КОНЕЦ,
	|	ТаблицаДокумента.Номенклатура,
	|	ТаблицаДокумента.Количество * ЕСТЬNULL(ТаблицаДокумента.ЕдиницаИзмерения.Коэффициент, 1) / ТаблицаДокумента.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Количество
	|ИЗ
	|	Документ.уатВнутреннееПеремещение.Товары КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка");
	ЗапросЯчейки.УстановитьПараметр("Ссылка", ДокументСсылка);
	тблТоварыВЯчейках = ЗапросЯчейки.Выполнить().Выгрузить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатТоварыВЯчейках");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = тблТоварыВЯчейках;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад", "Склад");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ячейка", "Ячейка");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТоварыВЯчейках", тблТоварыВЯчейках);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	мЗапрос = Новый Запрос;
	мЗапрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц; 
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке)
	|			ТОГДА ТаблицаДокумента.Ссылка.Склад.ТранзитнаяЯчейка
	|		ИНАЧЕ ТаблицаДокумента.ЯчейкаОтправитель
	|	КОНЕЦ КАК Ячейка,
	|	ТаблицаДокумента.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ тблДокумента
	|ИЗ
	|	Документ.уатВнутреннееПеремещение.Товары КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Номенклатура,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке)
	|			ТОГДА ТаблицаДокумента.Ссылка.Склад.ТранзитнаяЯчейка
	|		ИНАЧЕ ТаблицаДокумента.ЯчейкаОтправитель
	|	КОНЕЦ,
	|	ТаблицаДокумента.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Ячейка КАК Ячейка,
	|	ТаблицаДокумента.Ссылка КАК Регистратор,
	|	ЕСТЬNULL(уатТоварыВЯчейкахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	тблДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатТоварыВЯчейках.Остатки(
	|				&МоментВремени,
	|				Склад = &Склад
	|					И Номенклатура В
	|						(ВЫБРАТЬ
	|							ТабНоменклатуры.Номенклатура
	|						ИЗ
	|							Документ.уатВнутреннееПеремещение.Товары КАК ТабНоменклатуры
	|						ГДЕ
	|							ТабНоменклатуры.Ссылка = &Ссылка)) КАК уатТоварыВЯчейкахОстатки
	|		ПО ТаблицаДокумента.Номенклатура = уатТоварыВЯчейкахОстатки.Номенклатура
	|			И ТаблицаДокумента.Ячейка = уатТоварыВЯчейкахОстатки.Ячейка
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И ЕСТЬNULL(уатТоварыВЯчейкахОстатки.КоличествоОстаток, 0) < 0";
	
	Если УдалениеПроведения Тогда
		мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст, "&МоментВремени", "");
		мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст, "ЯчейкаОтправитель", "ЯчейкаПолучатель");
		мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст, "уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке",
			"уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки");
	КонецЕсли;
	мЗапрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	мЗапрос.УстановитьПараметр("Склад", ДокументСсылка.Склад);
	мЗапрос.УстановитьПараметр("МоментВремени", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
	Выборка = мЗапрос.Выполнить().Выбрать();
	Если Выборка.Количество() тогда
		Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
		Пока Выборка.Следующий() Цикл
			ТекстНСТР = СтрШаблон("Обнаружен отрицательный остаток номенклатуры ""%1"" на складе ""%2"" в ячейке ""%3"": %4",
				Выборка.Номенклатура, мЗапрос.Параметры.Склад, Выборка.Ячейка, Выборка.КоличествоОстаток);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

// Получает дополнительные реквизиты для отображения в отчете "Реестр документов"
// 
// Возвращаемое значение:
//  Структура - доп. реквизитов
//
Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Склад");
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьНаОснованииИнвентаризации(ДокументОбъект, ДанныеЗаполнения, ВидОперации) Экспорт
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокументаПоОснованию(ДокументОбъект, ДанныеЗаполнения);
	
	ДокументОбъект.Дата = ТекущаяДата();
	ДокументОбъект.ВидОперации = ВидОперации;
	ДокументОбъект.ДокументОснование = ДанныеЗаполнения.Ссылка;
	ДокументОбъект.Склад = ДанныеЗаполнения.Склад;
	
	Для Каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
		Если ВидОперации = Перечисления.уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки
			И ТекСтрока.Количество < ТекСтрока.КоличествоУчет Тогда
			
			НоваяСтрока				 	  = ДокументОбъект.Товары.Добавить();
			НоваяСтрока.Номенклатура 	  = ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения  = ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 	 	  = ТекСтрока.КоличествоУчет - ТекСтрока.Количество;
			НоваяСтрока.ЯчейкаОтправитель = ТекСтрока.Ячейка;
			
		ИначеЕсли ВидОперации = Перечисления.уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке
			И ТекСтрока.Количество > ТекСтрока.КоличествоУчет Тогда
			
			НоваяСтрока				 	  = ДокументОбъект.Товары.Добавить();
			НоваяСтрока.Номенклатура 	  = ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения  = ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 	 	  = ТекСтрока.Количество - ТекСтрока.КоличествоУчет;
			НоваяСтрока.ЯчейкаПолучатель  = ТекСтрока.Ячейка;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПечатьВнутреннееПеремещение(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ВнутреннееПеремещение";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		Если ТекущийДокумент.ВидОперации <> Перечисления.уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки
			И ТекущийДокумент.ВидОперации <> Перечисления.уатВидыОперацийВнутреннееПеремещение.ПеремещениеМеждуЯчейками Тогда
			ТекстНСТР = НСтр("ru='%1 не выведен на печать: вид операции должен быть ""Извлечение"" или ""Перемещение"".'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекущийДокумент);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР,,, СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатВнутреннееПеремещение.Номер,
		|	уатВнутреннееПеремещение.Дата,
		|	уатВнутреннееПеремещение.Организация,
		|	уатВнутреннееПеремещение.Склад,
		|	уатВнутреннееПеремещение.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК Товар,
		|		Номенклатура.Код КАК Код,
		|		Номенклатура.Артикул КАК Артикул,
		|		Количество,
		|		ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
		|		ЯчейкаОтправитель.Представление КАК ЯчейкаОтправитель
		|	)
		|ИЗ
		|	Документ.уатВнутреннееПеремещение КАК уатВнутреннееПеремещение
		|ГДЕ
		|	уатВнутреннееПеремещение.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	уатВнутреннееПеремещение.Товары.НомерСтроки");
		
		ТекстКодАртикул = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(), "РежимВыводаКодаВДокументах");
		Если ТекстКодАртикул = Перечисления.уатРежимыВыводаКодаВДокументах.Артикул Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Номенклатура.Код", "Номенклатура.Артикул");
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВнутреннееПеремещение_Накладная";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатПеремещениеТоваров.ПФ_MXL_СборочныйЛист");
		
		// Печать штрихкода
		Если уатЗащищенныеФункцииСервер_проф.ИспользоватьШтрихкодированиеОбъекта(ТекущийДокумент) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокШтрихкод");
			уатЗащищенныеФункцииСервер_проф.ОтобразитьШКнаПФ(ОбластьМакета, ТекущийДокумент);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// Выводим шапку накладной
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(Шапка,
			НСтр("en='Invoice on inner movement';ru='Сборочный лист'"));
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Склад");
		ОбластьЗаголовок.Параметры.Склад = Шапка.Склад;
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// Вывести табличную часть
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		
		// Выборка товаров
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		КонецЦикла;
		
		// Вывести подвал
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		// Вывести подписи
		ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
		ОбластьПодписи.Параметры.Отпустил = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Отпустил);
		ОбластьПодписи.Параметры.Получил  = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Получил);
		ТабличныйДокумент.Вывести(ОбластьПодписи);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция помещает необходимые данные в структуру. Структура помещается во временное хранилище.
//
// Возвращаемое значение:
//   Строка - адрес структуры данных во временном хранилище.
//
Функция ДанныеДляПечатиЭтикеток(МассивДокументов) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Товары.Количество КАК КоличествоЭтикеток,
	|	Товары.Количество КАК КоличествоВДокументе
	|ИЗ
	|	Документ.уатВнутреннееПеремещение.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В(&МассивДокументов)";
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	мсвТовары = Запрос.Выполнить().Выгрузить();
	
	// Подготовка данных для заполенения табличной части обработки печати этикеток.
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Товары", мсвТовары);
	СтруктураРезультат.Вставить("Организация", МассивДокументов[0].Организация);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураРезультат);
	
КонецФункции

#КонецОбласти

#КонецЕсли