#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Позволяет определить список заблокированных реквизитов.
// 
// Возвращаемое значение:
//  Массив - из Строка - строки в формате "ИмяРеквизита[;ИмяЭлементаФормы,...]",
//  где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
//  имя элемента формы, связанного с реквизитом. Например: "Объект.Автор", "ПолеАвтор".
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив();
	
	БлокируемыеРеквизиты.Добавить("УникальноеГрузовоеМесто");
	БлокируемыеРеквизиты.Добавить("Контейнер");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// Запрещает/разрешает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла".
// 
// Возвращаемое значение:
//  Булево - флаг использования
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Истина;
КонецФункции

// Переопределяет параметры загрузки данных из файла.
//
// Параметры:
//  Параметры - Структура:
//   * ИмяМакетаСШаблоном - Строка - наименование макета. Например, "ЗагрузкаИзФайла".
//   * ИмяТабличнойЧасти - Строка - полное имя табличной части. Например, "Документ._ДемоСчетНаОплатуПокупателю.ТабличнаяЧасть.Товары"
//   * ОбязательныеКолонки - Массив из Строка - наименования обязательных для заполнения колонок.
//   * ТипДанныхКолонки - Соответствие из КлючИЗначение:
//      * Ключ - Строка - имя колонки;
//      * Значение - ОписаниеТипов - тип колонки загружаемых данных.
//   * ДополнительныеПараметры - Структура
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
//  с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//  АдресЗагружаемыхДанных		 - 	 - 
//  АдресТаблицыСопоставления	 - 	 - 
//  СписокНеоднозначностей		 - 	 - 
//  ПолноеИмяТабличнойЧасти		 - 	 - 
//  ДополнительныеПараметры		 - 	 - 
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Если ПолноеИмяТабличнойЧасти = "Справочник.уатГрузовыеМеста_уэ.ТабличнаяЧасть.ТоварныйСостав" Тогда 
		СопоставитьЗагружаемыеДанныеТоварныйСостав(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ДополнительныеПараметры);
	ИначеЕсли ПолноеИмяТабличнойЧасти = "Справочник.уатГрузовыеМеста_уэ.ТабличнаяЧасть.ГрузовойСостав" Тогда 
		СопоставитьЗагружаемыеДанныеГрузовойСостав(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ДополнительныеПараметры);	
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список подходящих объектов ИБ для неоднозначного значения ячейки.
//
// Параметры:
//  ПолноеИмяТабличнойЧасти		 - 	 - 
//  СписокНеоднозначностей		 - 	 - 
//  ИмяКолонки					 - 	 - 
//  ЗагружаемыеЗначенияСтрока	 - 	 - 
//  ДополнительныеПараметры		 - 	 - 
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Если ИмяКолонки = "Номенклатура" Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.Номенклатура);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Наименование = &Наименование";
		
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокНеоднозначностей.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает параметры загрузки данных из файла
//
// Параметры:
//  Параметры	 - 	 - 
//
Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(Параметры) Экспорт
	
	Параметры.Заголовок = НСтр("en='Cargo spaces';ru='Грузовые места'");
	
	ОписаниеТипаКоличество =  Новый ОписаниеТипов("Число",, Новый КвалификаторыЧисла(15,3));
	Параметры.ТипДанныхКолонки.Вставить("Количество", ОписаниеТипаКоличество);
	
КонецПроцедуры

Функция ПолучитьПараметрыОткрытияОтчетОстаткиГрузовВКонтейнере(Ссылка) Экспорт
	
	СхемаКомпоновкиДанных = Отчеты.уатОстаткиГрузовВКонтейнерах_уэ.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	Если ЗначениеЗаполнено(Ссылка) И Не Ссылка.ЭтоГруппа Тогда
		Для Каждого ТекЭлем Из НастройкиКомпоновки.Отбор.Элементы Цикл
			Если Строка(ТекЭлем.ЛевоеЗначение) = "Контейнер"  Тогда
				ТекЭлем.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				ТекЭлем.ПравоеЗначение = Ссылка;
				ТекЭлем.Использование = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиКомпоновки);
	
	сткПараметры = Новый Структура("СформироватьПриОткрытии, ПользовательскиеНастройки", Истина, КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
	
	Возврат сткПараметры;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СопоставитьЗагружаемыеДанныеТоварныйСостав(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ДополнительныеПараметры)
	
	ТоварныйСостав = ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДляСопоставления.Номенклатура КАК Номенклатура,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставления
	|ИЗ
	|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(СправочникНоменклатура.Ссылка) КАК Ссылка,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО (СправочникНоменклатура.Наименование ПОДОБНО ДанныеДляСопоставления.Номенклатура)
	|ГДЕ
	|	НЕ СправочникНоменклатура.Ссылка ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Идентификатор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНоменклатура = РезультатЗапроса.Выгрузить();
	
	МенеджерВременныхТаблиц.Закрыть();
	
	мТекПользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Для Каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		Товар = ТоварныйСостав.Добавить();
		Товар.Идентификатор  = СтрокаТаблицы.Идентификатор;
		Товар.Количество     = ?(СтрокаТаблицы.Количество = 0, 1, СтрокаТаблицы.Количество);
		Товар.СтавкаНДС      = СтавкаНДСПоПредставлению(СтрокаТаблицы.СтавкаНДС);
		Товар.Цена           = СтрокаТаблицы.Цена;
		Товар.Сумма          = Товар.Количество * Товар.Цена;	
				
		СтрокаНоменклатура = ТаблицаНоменклатура.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
					
		Если СтрокаНоменклатура = Неопределено И Не ПустаяСтрока(СтрокаТаблицы.Номенклатура) Тогда // Создание нового элемента.
			НовыйЭлемент = Справочники.Номенклатура.СоздатьЭлемент();
			НовыйЭлемент.УстановитьНовыйКод();
			НовыйЭлемент.Наименование = СтрокаТаблицы.Номенклатура;
			НовыйЭлемент.НаименованиеПолное = СтрокаТаблицы.Номенклатура;
			НовыйЭлемент.Услуга = Ложь;
			НовыйЭлемент.ВидНоменклатуры = Справочники.ВидыНоменклатуры.Товар;
			НовыйЭлемент.ЕдиницаИзмерения = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
				мТекПользователь, "ОсновнаяЕдиницаПоКлассификатору");
			НовыйЭлемент.СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
				мТекПользователь, "ОсновнаяСтавкаНДС");
				
			Попытка
				НовыйЭлемент.Записать();
			Исключение
			КонецПопытки;
			
			Если Не НовыйЭлемент.Ссылка.Пустая() Тогда
								
				Товар.Номенклатура = НовыйЭлемент.Ссылка;
				// Нужно еще заполнить единицу хранения остатков для подстановки в ТЧ.
				Если ЗначениеЗаполнено(НовыйЭлемент.ЕдиницаИзмерения) Тогда
					НоваяЕдиницаОстатков = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
					НоваяЕдиницаОстатков.Владелец = НовыйЭлемент.Ссылка;
					НоваяЕдиницаОстатков.Наименование = Строка(НовыйЭлемент.ЕдиницаИзмерения);
					НоваяЕдиницаОстатков.ЕдиницаПоКлассификатору = НовыйЭлемент.ЕдиницаИзмерения;
					НоваяЕдиницаОстатков.Коэффициент = 1;
					Попытка
						НоваяЕдиницаОстатков.Записать();
					Исключение
					КонецПопытки;
					Если НЕ НоваяЕдиницаОстатков.Ссылка.Пустая() Тогда
						НовыйЭлемент.ЕдиницаХраненияОстатков = НоваяЕдиницаОстатков.Ссылка;
						Попытка
							НовыйЭлемент.Записать();
						Исключение
						КонецПопытки;
					КонецЕсли;
				КонецЕсли;
				
				// Запись весо-объемных характеристик новой единицы номенклатуры в регистр сведений
				МенеджерЗаписи = РегистрыСведений.уатНоменклатураГрузов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.ЕдиницаИзмерения = НовыйЭлемент.ЕдиницаХраненияОстатков;
				МенеджерЗаписи.Номенклатура     = НовыйЭлемент.Ссылка;
				МенеджерЗаписи.Вес				= ?(ЗначениеЗаполнено(СтрокаТаблицы.Вес),Строкатаблицы.Вес, 0);
				МенеджерЗаписи.ВысотаГруза		= ?(ЗначениеЗаполнено(СтрокаТаблицы.Высота),Строкатаблицы.Высота, 0);;
				МенеджерЗаписи.ДлинаГруза		= ?(ЗначениеЗаполнено(СтрокаТаблицы.Длина),Строкатаблицы.Длина, 0);;
				МенеджерЗаписи.ШиринаГруза		= ?(ЗначениеЗаполнено(СтрокаТаблицы.Ширина),Строкатаблицы.Ширина, 0);;
				МенеджерЗаписи.Объем			= МенеджерЗаписи.ВысотаГруза * МенеджерЗаписи.ДлинаГруза * МенеджерЗаписи.ШиринаГруза;
				
				Попытка
					МенеджерЗаписи.Записать();
				Исключение
				КонецПопытки;

			КонецЕсли;
			
		ИначеЕсли Не СтрокаНоменклатура = Неопределено Тогда 
			Если СтрокаНоменклатура.Количество = 1 Тогда 
				Товар.Номенклатура = СтрокаНоменклатура.Ссылка;
			ИначеЕсли СтрокаНоменклатура.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "Номенклатура";
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Товар.Номенклатура) Тогда
			Товар.ЕдиницаИзмерения = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Товар.Номенклатура, "ЕдиницаХраненияОстатков");
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТоварныйСостав, АдресТаблицыСопоставления);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеГрузовойСостав(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ДополнительныеПараметры)
	
	ТоварныйСостав = ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДляСопоставления.ГрузовоеМесто КАК ГрузовоеМесто,
	|	ДанныеДляСопоставления.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставления
	|ИЗ
	|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(уатГрузовыеМеста_уэ.Ссылка) КАК Ссылка,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.уатГрузовыеМеста_уэ КАК уатГрузовыеМеста_уэ
	|		ПО (уатГрузовыеМеста_уэ.Наименование ПОДОБНО ДанныеДляСопоставления.ГрузовоеМесто)
	|ГДЕ
	|	НЕ уатГрузовыеМеста_уэ.Ссылка ЕСТЬ NULL
	|	И НЕ уатГрузовыеМеста_уэ.Контейнер
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(уатВидыУпаковки_уэ.Ссылка) КАК Ссылка,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор,
	|	КОЛИЧЕСТВО(ДанныеДляСопоставления.Идентификатор) КАК Количество
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.уатВидыУпаковки_уэ КАК уатВидыУпаковки_уэ
	|		ПО (уатВидыУпаковки_уэ.Наименование ПОДОБНО ДанныеДляСопоставления.ЕдиницаИзмерения)
	|ГДЕ
	|	НЕ уатВидыУпаковки_уэ.Ссылка ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Идентификатор";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаНоменклатура = РезультатЗапроса[1].Выгрузить();
	ТаблицаВидыУпаковки = РезультатЗапроса[2].Выгрузить();
	
	МенеджерВременныхТаблиц.Закрыть();
	
	мТекПользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Для Каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		Товар = ТоварныйСостав.Добавить();
		Товар.Идентификатор  = СтрокаТаблицы.Идентификатор;
		Товар.Количество     = ?(СтрокаТаблицы.Количество = 0, 1, СтрокаТаблицы.Количество);
		Товар.СтавкаНДС      = СтавкаНДСПоПредставлению(СтрокаТаблицы.СтавкаНДС);
		Товар.Цена           = СтрокаТаблицы.Цена;
		Товар.Сумма          = Товар.Количество * Товар.Цена;	
				
		СтрокаНоменклатура = ТаблицаНоменклатура.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
					
		Если СтрокаНоменклатура = Неопределено И Не ПустаяСтрока(СтрокаТаблицы.ГрузовоеМесто) Тогда // Создание нового элемента.
			НовыйЭлемент = Справочники.уатГрузовыеМеста_уэ.СоздатьЭлемент();
			НовыйЭлемент.УстановитьНовыйКод();
			НовыйЭлемент.Наименование       = СтрокаТаблицы.ГрузовоеМесто;
			
			СтрокаВидУпаковки = ТаблицаВидыУпаковки.Найти(СтрокаТаблицы.Идентификатор, "Идентификатор");
			Если СтрокаВидУпаковки = Неопределено И Не ПустаяСтрока(СтрокаТаблицы.ЕдиницаИзмерения) Тогда 
				НовыйЭлементВП = Справочники.уатВидыУпаковки_уэ.СоздатьЭлемент();
				НовыйЭлементВП.УстановитьНовыйКод();
				НовыйЭлементВП.Наименование = СтрокаТаблицы.ЕдиницаИзмерения;
				НовыйЭлементВП.Коэффициент = 1;
				Попытка
					НовыйЭлементВП.Записать();
					НовыйЭлемент.ВидУпаковки = НовыйЭлементВП.Ссылка;
				Исключение
				КонецПопытки;
				
			ИначеЕсли Не СтрокаВидУпаковки = Неопределено Тогда 
				Если СтрокаВидУпаковки.Количество = 1 Тогда 
					НовыйЭлемент.ВидУпаковки = СтрокаВидУпаковки.Ссылка;
				ИначеЕсли СтрокаВидУпаковки.Количество > 1 Тогда
					ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
					ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.ЕдиницаИзмерения; 
					ЗаписьОНеоднозначности.Колонка = "ВидУпаковки";
				КонецЕсли;
			КонецЕсли;

			НовыйЭлемент.ВидУпаковки        = Справочники.уатВидыУпаковки_уэ.ПолучитьОсновнойВидУпаковки();
			НовыйЭлемент.ВесБрутто          = СтрокаТаблицы.Вес;
			НовыйЭлемент.КоличествоМест     = ?(СтрокаТаблицы.КоличествоМест =0, 1, СтрокаТаблицы.КоличествоМест);
			НовыйЭлемент.Объем              = СтрокаТаблицы.Объем;
			НовыйЭлемент.Длина              = СтрокаТаблицы.Длина;
			НовыйЭлемент.Ширина             = СтрокаТаблицы.Длина;
			НовыйЭлемент.Высота             = СтрокаТаблицы.Высота;
			Попытка
				НовыйЭлемент.Записать();
			Исключение
			КонецПопытки;
		ИначеЕсли Не СтрокаНоменклатура = Неопределено Тогда 
			Если СтрокаНоменклатура.Количество = 1 Тогда 
				Товар.ГрузовоеМесто = СтрокаНоменклатура.Ссылка;
			ИначеЕсли СтрокаНоменклатура.Количество > 1 Тогда
				ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
				ЗаписьОНеоднозначности.Идентификатор = СтрокаТаблицы.Идентификатор; 
				ЗаписьОНеоднозначности.Колонка = "ГрузовоеМесто";
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Товар.ГрузовоеМесто) Тогда
			Товар.ЕдиницаИзмерения = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Товар.ГрузовоеМесто, "ВидУпаковки");
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ТоварныйСостав, АдресТаблицыСопоставления);
	
КонецПроцедуры

Функция СтавкаНДСПоПредставлению(НаименованиеСтавки)
	
	ТабСтавок = Новый ТаблицаЗначений();
	ТабСтавок.Колонки.Добавить("Ссылка",       Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
	ТабСтавок.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	
	Для Каждого ТекЗначение Из Метаданные.Перечисления.СтавкиНДС.ЗначенияПеречисления Цикл 
		НовСтавка = ТабСтавок.Добавить();
		НовСтавка.Ссылка       = Перечисления.СтавкиНДС[ТекЗначение.Имя];
		НовСтавка.Наименование = ТекЗначение.Синоним;
		
		Если СтрНайти(НовСтавка.Наименование, "%") Тогда
			НовСтавка = ТабСтавок.Добавить();
			НовСтавка.Ссылка       = Перечисления.СтавкиНДС[ТекЗначение.Имя];
			НовСтавка.Наименование = СтрЗаменить(ТекЗначение.Синоним, "%", "");
		КонецЕсли;
	КонецЦикла;
	
	НайдСтавка = ТабСтавок.Найти(НаименованиеСтавки, "Наименование");
	
	Если НайдСтавка = Неопределено Тогда 
		Возврат Перечисления.СтавкиНДС.ПустаяСсылка();
	Иначе 
		Возврат НайдСтавка.Ссылка;
	КонецЕсли;
	
КонецФункции // СтавкаНДСПоПредставлению()

Процедура РассчитатьХарактеристикиПоТоварномуСоставу(Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидУпаковки)
		И НЕ Объект.Контейнер Тогда 
		Объект.ВидУпаковки = Справочники.уатВидыУпаковки_уэ.ПолучитьОсновнойВидУпаковки();
	КонецЕсли;
	
	ВесБрутто           = 0;  
	Объем               = 0;  
	КоличествоМест      = 0;
	ВесТарыНоменклатуры = 0;
	
	Для Каждого ТекСоставГрузМеста Из Объект.ТоварныйСостав Цикл
		Если ЗначениеЗаполнено(ТекСоставГрузМеста.ЕдиницаИзмерения) Тогда
			ЕдиницаИзмерения = ТекСоставГрузМеста.ЕдиницаИзмерения;
			
		Иначе
			ЕдиницаИзмерения = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
				ТекСоставГрузМеста.Номенклатура,
				"ЕдиницаХраненияОстатков"
			);
		КонецЕсли;
		
		ВесОбъем = уатОбщегоНазначения.ПолучитьВесОбъемНоменклатуры(ТекСоставГрузМеста.Номенклатура, ЕдиницаИзмерения, ТекСоставГрузМеста.Количество);
		ВесБрутто      = ВесБрутто + ВесОбъем.Вес;
		Объем          = Объем + ВесОбъем.Объем;
		КоличествоМест = КоличествоМест + ВесОбъем.КоличествоМест;
		
		РаспределениеПоУпаковкам = уатОбщегоНазначения_уэ.УпаковатьНоменклатуру(ТекСоставГрузМеста.Номенклатура, ТекСоставГрузМеста.Количество);
		ВесТарыНоменклатуры = ВесТарыНоменклатуры + уатОбщегоНазначения_уэ.ПолучитьВесТарыПоУпаковкам(РаспределениеПоУпаковкам);
		
		Если Не ЗначениеЗаполнено(Объект.ВидГруза) Тогда
			Объект.ВидГруза = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
				ТекСоставГрузМеста.Номенклатура,
				"уатВидГруза"
			);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекДанные Из Объект.ГрузовойСостав Цикл
		РеквизитыГрузовогоМеста = уатОбщегоНазначенияТиповые.ПолучитьЗначенияРеквизитов(ТекДанные.ГрузовоеМесто,
		"ВидУпаковки,ТипКонтейнера,Контейнер,ВесБрутто,ВесТары,КоличествоМест,Объем,Длина,Ширина,Высота,Стоимость");
		Если ЗначениеЗаполнено(ТекДанные.ЕдиницаИзмерения) Тогда
			ЕдиницаИзмерения = ТекДанные.ЕдиницаИзмерения;
			
		ИначеЕсли РеквизитыГрузовогоМеста.Контейнер Тогда
			ЕдиницаИзмерения = РеквизитыГрузовогоМеста.ТипКонтейнера;
		Иначе
			ЕдиницаИзмерения = РеквизитыГрузовогоМеста.ВидУпаковки;
		КонецЕсли;
		
		ВесБрутто      = ВесБрутто + РеквизитыГрузовогоМеста.ВесБрутто;
		Объем          = Объем + РеквизитыГрузовогоМеста.Объем;
		КоличествоМест = КоличествоМест + РеквизитыГрузовогоМеста.КоличествоМест;
		ВесТарыНоменклатуры = ВесТарыНоменклатуры + РеквизитыГрузовогоМеста.ВесТары;
		
	КонецЦикла;
	
	Объект.ВесБрутто      = ВесБрутто;
	Объект.Объем          = Объем;
	
	Если НЕ Объект.Контейнер Тогда 
		Объект.КоличествоМест = КоличествоМест;
		ВесТарыГМ = Объект.ВидУпаковки.ВесТары * Объект.КоличествоМест;
		Объект.ВесТары = ВесТарыГМ + ВесТарыНоменклатуры;
	Иначе
		Объект.КоличествоМест = 1;
	КонецЕсли;
	
	Объект.Стоимость = Объект.ТоварныйСостав.Итог("Сумма") + Объект.ГрузовойСостав.Итог("Сумма");
	Если Объект.УчитыватьНДС И Не Объект.СуммаВключаетНДС Тогда
		Объект.Стоимость = Объект.Стоимость + Объект.ТоварныйСостав.Итог("СуммаНДС") + Объект.ГрузовойСостав.Итог("СуммаНДС");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли