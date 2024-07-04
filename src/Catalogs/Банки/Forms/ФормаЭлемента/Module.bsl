
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Код <> "" Тогда
			БИК = СокрЛП(Параметры.Код);
			Объект.Код = БИК;
		КонецЕсли;
		
		Если Параметры.КоррСчет <> "" Тогда
			Объект.КоррСчет = Параметры.КоррСчет;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.РучноеИзменение = ?(РучноеИзменение = Неопределено, 2, РучноеИзменение);
	
	Если ТекущийОбъект.Страна <> Справочники.СтраныМира.Россия Тогда
		ТекущийОбъект.КоррСчет = "";
		ТекущийОбъект.Город = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СВИФТБИКПриИзменении(Элемент)
	
	Объект.СВИФТБИК = ВРег(СокрЛП(Объект.СВИФТБИК));
	
	Если БанковскиеПравила_СтрокаСоответствуетФорматуSWIFT(Объект.СВИФТБИК) Тогда
		
		СтранаБанка = СтранаПоSWIFT(Объект.СВИФТБИК);
		
		Если ЗначениеЗаполнено(СтранаБанка) Тогда
			Объект.Страна = СтранаБанка;
		КонецЕсли;
		
		ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросИзменитьЗавершение", ЭтотОбъект);
	
	Текст = НСтр("en='Supply data is updated automatically."
"After manual change of the automatic update of this element will not be made."
"To continue with the change?';ru='Поставляемые данные обновляются автоматически."
"После ручного изменения автоматическое обновление этого элемента производиться не будет."
"Продолжить с изменением?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросОбновитьИзКлассификатораЗавершение", ЭтотОбъект);
	
	Текст = НСтр("en='Data element will be replaced with data from the classifier."
"All manual changes will be lost. Continue?';ru='Данные элемента будут заменены данными из классификатора."
"Все ручные изменения будут потеряны. Продолжить?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	// Код банка.
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Код");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Страна", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СтраныМира.Россия);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРеквизитыЗависимыеОтСтраны(Форма)
	
	ЯвляетсяБанкомРФ = (Форма.Объект.Страна = Форма.СтранаРФ);
	
	Форма.Элементы.КоррСчет.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Город.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ТекстРучногоИзменения.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ОбновитьИзКлассификатора.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Изменить.Видимость = ЯвляетсяБанкомРФ;
	
	Если ЯвляетсяБанкомРФ Тогда
		Форма.Элементы.Код.Заголовок = НСтр("en='BIC';ru='БИК'");
	Иначе
		Форма.Элементы.Код.Заголовок = НСтр("en='National code';ru='Национальный код'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Банки);
	РаботаСБанкамиБП_СчитатьФлагРучногоИзменения(ЭтотОбъект, МожноРедактировать);
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьПрекращена;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтранаПоSWIFT(СВИФТБИК)
	Возврат Справочники.Банки.СтранаПоSWIFT(СВИФТБИК);
КонецФункции

&НаКлиенте
Процедура ВопросИзменитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		РучноеИзменение    = Истина;
		РаботаСБанкамиКлиентПереопределяемый_ОбработатьФлагРучногоИзменения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбновитьИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ОбновитьНаСервере();
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	РаботаСБанкамиБП_ВосстановитьЭлементИзОбщихДанных(ЭтотОбъект);
	
КонецПроцедуры

#Область ПроцедурыИФункцииОбщихМодулейБП

// Считывает текущее состояние объекта и приводит форму в соответстие с ним.
//
&НаСервереБезКонтекста
Процедура РаботаСБанкамиБП_СчитатьФлагРучногоИзменения(Форма, Знач МожноРедактировать)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Банки.РучноеИзменение КАК РучноеИзменение
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Форма.Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Форма.РучноеИзменение = Неопределено;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.РучноеИзменение = 2 Тогда
			Форма.РучноеИзменение = Неопределено;
		ИначеЕсли Выборка.РучноеИзменение = 1 Тогда
			Форма.РучноеИзменение = Истина;
		Иначе
			Форма.РучноеИзменение = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.РучноеИзменение <> Неопределено Тогда
		СсылкаНаКлассификатор = РаботаСБанкамиБП_СсылкаПоКлассификатору(Форма.Объект.Код);
		Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
			Форма.ДеятельностьПрекращена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаКлассификатор, "ДеятельностьПрекращена");
		КонецЕсли;
	КонецЕсли;
	
	РаботаСБанкамиБП_ОбработатьФлагРучногоИзменения(Форма, МожноРедактировать);
	
КонецПроцедуры

// Задает текст состояние разделнного объекта, устанавливает доступность
// кнопок управления состоянием и флага ТолькоПросмотр формы.
//
&НаСервереБезКонтекста
Процедура РаботаСБанкамиБП_ОбработатьФлагРучногоИзменения(Форма, Знач МожноРедактировать)
	
	Элементы  = Форма.Элементы;
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		Если Форма.ДеятельностьПрекращена Тогда
			Форма.ТекстРучногоИзменения = "";
		Иначе
			Форма.ТекстРучногоИзменения = НСтр("en='Item is created manually. Automatic updating is impossible.';ru='Элемент создан вручную. Автоматическое обновление невозможно.'");
		КонецЕсли;
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = НЕ МожноРедактировать;
		Элементы.Родитель.Доступность = МожноРедактировать;
		Элементы.Код.Доступность      = МожноРедактировать;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = МожноРедактировать;
		КонецЕсли;
	ИначеЕсли Форма.РучноеИзменение = Истина Тогда
		Форма.ТекстРучногоИзменения = НСтр("en='Element auto update is disabled.';ru='Автоматическое обновление элемента отключено.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = МожноРедактировать;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = НЕ МожноРедактировать;
		Элементы.Родитель.Доступность = Ложь;
		Элементы.Код.Доступность      = Ложь;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Форма.ТекстРучногоИзменения = НСтр("en='Element is updated automatically.';ru='Элемент обновляется автоматически.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = МожноРедактировать;
		Форма.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РаботаСБанкамиБП_СсылкаПоКлассификатору(БИК, Коррсчет = "", ЭтоРегион = Ложь)
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Справочники.КлассификаторБанков.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КлассификаторБанковРФ.Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Код = &БИК
	|	И КлассификаторБанковРФ.ЭтоГруппа = &ЭтоГруппа
	|	И КлассификаторБанковРФ.КоррСчет = &Коррсчет";
	
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Если ЭтоРегион Тогда
		Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
	Иначе
		Если ПустаяСтрока(Коррсчет) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И КлассификаторБанковРФ.ЭтоГруппа = &ЭтоГруппа", "");
		Иначе
			Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Коррсчет) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И КлассификаторБанковРФ.КоррСчет = &Коррсчет", "");
	Иначе
		Запрос.УстановитьПараметр("Коррсчет", Коррсчет);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.КлассификаторБанков.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

// Функция проверяет соответствие строки банковскому коду SWIFT.
//
// Параметры:
//  ПроверяемаяСтрока - Строка - строка которую, требуется проверить на соответствие SWIFT коду.
// 
// Возвращаемое значение:
//  Булево - если Истина - строка соответствует формату SWIFT. 
//
&НаСервереБезКонтекста
Функция БанковскиеПравила_СтрокаСоответствуетФорматуSWIFT(ПроверяемаяСтрока)
	
	ДлинаКода = СтрДлина(ПроверяемаяСтрока);
	ДлинаДляЦО = 8; 
	ДлинаДляФилиала = 11;
	ПроверитьДлинуSWIFT = (ДлинаКода = ДлинаДляЦО Или ДлинаКода = ДлинаДляФилиала);
	
	ПроверитьРазрешенныеСимволыSWIFT = Истина;
	Для ИндексСимвола = 1 По СтрДлина(ПроверяемаяСтрока) Цикл
		
		СимволКода = ВРег(Сред(ПроверяемаяСтрока, ИндексСимвола, 1));
		
		Если СтрНайти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", СимволКода) = 0 Тогда
			ПроверитьРазрешенныеСимволы = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат (ПроверитьДлинуSWIFT И ПроверитьРазрешенныеСимволыSWIFT);
	
КонецФункции

// Задает текст состояние разделнного объекта, устанавливает доступность
// кнопок управления состоянием и флага ТолькоПросмотр формы
//
&НаКлиенте
Процедура РаботаСБанкамиКлиентПереопределяемый_ОбработатьФлагРучногоИзменения(Знач Форма)
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		Форма.ТекстРучногоИзменения = НСтр("en='Item is created manually. Automatic update not possible.';ru='Элемент создан вручную. Автоматическое обновление не возможно.'");
		
		Форма.Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Форма.Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Форма.Элементы.Родитель.Доступность = Истина;
		Форма.Элементы.Код.Доступность      = Истина;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Форма.Элементы.КоррСчет.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли Форма.РучноеИзменение = Истина Тогда
		Форма.ТекстРучногоИзменения = НСтр("en='Element auto update is disabled.';ru='Автоматическое обновление элемента отключено.'");
		
		Форма.Элементы.ОбновитьИзКлассификатора.Доступность = Истина;
		Форма.Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = Ложь;
		Форма.Элементы.Родитель.Доступность = Ложь;
		Форма.Элементы.Код.Доступность      = Ложь;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Форма.Элементы.КоррСчет.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Форма.ТекстРучногоИзменения = НСтр("en='Element is updated automatically.';ru='Элемент обновляется автоматически.'");
		
		Форма.Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Форма.Элементы.Изменить.Доступность = Истина;
		Форма.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Восстановление данных из общего объекта и изменяет состояние объекта.
//
&НаСервереБезКонтекста
Процедура РаботаСБанкамиБП_ВосстановитьЭлементИзОбщихДанных(Знач Форма)
	
	Банк = Форма.Объект;
	
	НачатьТранзакцию();
	Попытка
		Ссылки = Новый Массив;
		Классификатор = РаботаСБанкамиБП_СсылкаПоКлассификатору(Банк.Код, СокрЛП(Банк.КоррСчет));
		
		Если НЕ ЗначениеЗаполнено(Классификатор) Тогда
			Возврат;
		КонецЕсли;
		
		Ссылки.Добавить(Классификатор);
		РаботаСБанкамиБП_ПодобратьБанкИзКлассификатора(Ссылки, Истина);
		
		ДеятельностьПрекращена = Ложь;
		СсылкаНаКлассификатор  = РаботаСБанкамиБП_СсылкаПоКлассификатору(Банк.Код);
		Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
			СвойстваБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Классификатор, "ДеятельностьПрекращена, ЭтоГруппа");
			ДеятельностьПрекращена = НЕ СвойстваБанка.ЭтоГруппа И СвойстваБанка.ДеятельностьПрекращена;
		КонецЕсли;
		
		Форма.ДеятельностьПрекращена = ДеятельностьПрекращена;
		Если ДеятельностьПрекращена Тогда
			Форма.РучноеИзменение = Неопределено;
		Иначе
			Форма.РучноеИзменение = Ложь;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ШаблонСообщения = НСтр("en='Failed to recover from general data"
"%1';ru='Не удалось восстановить из общих данных"
"%1'");
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			НСтр("en='Banks classification';ru='Классификатор банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		
		ВызватьИсключение;
	КонецПопытки;
	
	Форма.Прочитать();
	
КонецПроцедуры

// Функция осуществляет подбор данных классификатора, для копирования в элемент справочника Банки.
// Если такого банка ещё нет, то он создается.
// Если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей.
//
// Параметры:
//
// - СсылкиБанков - Массив с элементами типа СправочникСсылка.КлассификаторБанковРФ - список значений классификатора
//   которые необходимо обработать
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
&НаСервереБезКонтекста
Функция РаботаСБанкамиБП_ПодобратьБанкИзКлассификатора(Знач СсылкиБанков, ИгнорироватьРучноеИзменение = Ложь)
	
	МассивБанков = Новый Массив;
	
	Если СсылкиБанков.Количество() = 0 Тогда
		Возврат МассивБанков;
	КонецЕсли;
	
	СсылкиИерархия = РаботаСБанкамиБП_ДополнитьМассивРодителямиСсылок(СсылкиБанков);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкиИерархия", СсылкиИерархия);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КлассификаторБанковРФ.Код КАК БИК,
	|	КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	КлассификаторБанковРФ.Наименование,
	|	КлассификаторБанковРФ.Город,
	|	КлассификаторБанковРФ.Адрес,
	|	КлассификаторБанковРФ.Телефоны,
	|	КлассификаторБанковРФ.ЭтоГруппа,
	|	КлассификаторБанковРФ.ДеятельностьПрекращена,
	|	КлассификаторБанковРФ.Родитель.Код,
	|	КлассификаторБанковРФ.СВИФТБИК
	|ПОМЕСТИТЬ ВТ_КлассификаторБанковРФ
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка В(&СсылкиИерархия)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БИК,
	|	КоррСчет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Банк,
	|	ВТ_КлассификаторБанковРФ.БИК КАК Код,
	|	ВТ_КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа КАК ЭтоРегион,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	ВТ_КлассификаторБанковРФ.Город,
	|	ВТ_КлассификаторБанковРФ.Адрес,
	|	ВТ_КлассификаторБанковРФ.Телефоны,
	|	ВТ_КлассификаторБанковРФ.СВИФТБИК,
	|	ВЫБОР
	|		КОГДА ВТ_КлассификаторБанковРФ.ДеятельностьПрекращена
	|			ТОГДА 3
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РучноеИзменение,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """") КАК РодительКод
	|ПОМЕСТИТЬ БанкиБезРодителей
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|			И ВТ_КлассификаторБанковРФ.ЭтоГруппа = Банки.ЭтоГруппа
	|ГДЕ
	|	НЕ ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)),
	|	ВТ_КлассификаторБанковРФ.БИК,
	|	NULL,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	0,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """")
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|			И ВТ_КлассификаторБанковРФ.ЭтоГруппа = Банки.ЭтоГруппа
	|ГДЕ
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	РодительКод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БанкиБезРодителей.Банк,
	|	БанкиБезРодителей.Код КАК Код,
	|	БанкиБезРодителей.КоррСчет,
	|	БанкиБезРодителей.ЭтоРегион КАК ЭтоРегион,
	|	БанкиБезРодителей.Наименование,
	|	БанкиБезРодителей.Город,
	|	БанкиБезРодителей.Адрес,
	|	БанкиБезРодителей.Телефоны,
	|	БанкиБезРодителей.РучноеИзменение,
	|	БанкиБезРодителей.РодительКод,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель,
	|	БанкиБезРодителей.СВИФТБИК
	|ИЗ
	|	БанкиБезРодителей КАК БанкиБезРодителей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО БанкиБезРодителей.РодительКод = Банки.Родитель
	|			И БанкиБезРодителей.ЭтоРегион = Банки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоРегион УБЫВ,
	|	Код";
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаБанков = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Ссылки = Новый Массив;
	Для каждого СтрокаТаблицыЗначений Из ТаблицаБанков Цикл
		
		ПараметрыОбъекта = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений);
		//УдалитьНеВалидныеКлючиСтруктуры(ПараметрыОбъекта);
		Для каждого КлючИЗначение Из ПараметрыОбъекта Цикл
			Если КлючИЗначение.Значение = Null ИЛИ КлючИЗначение.Ключ = "ЭтоГруппа" Тогда
				ПараметрыОбъекта.Удалить(КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Ссылки.Добавить(ПараметрыОбъекта);
		
	КонецЦикла;
	
	МассивБанков = РаботаСБанкамиБП_СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение);
	
	Возврат МассивБанков;
	
КонецФункции

&НаСервереБезКонтекста
Функция РаботаСБанкамиБП_ДополнитьМассивРодителямиСсылок(Знач Ссылки)
	
	ИмяТаблицы = Ссылки[0].Метаданные().ПолноеИмя();
	
	МассивСсылок = Новый Массив;
	Для каждого Ссылка Из Ссылки Цикл
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	ТекущиеСсылки = Ссылки;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Таблица.Родитель КАК Ссылка
	|ИЗ
	|	" + ИмяТаблицы + " КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В (&Ссылки)
	|	И Таблица.Родитель <> ЗНАЧЕНИЕ(" + ИмяТаблицы + ".ПустаяСсылка)";
	
	Пока Истина Цикл
		Запрос.УстановитьПараметр("Ссылки", ТекущиеСсылки);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Прервать;
		КонецЕсли;
		
		ТекущиеСсылки = Новый Массив;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекущиеСсылки.Добавить(Выборка.Ссылка);
			МассивСсылок.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивСсылок;
	
КонецФункции

// Функция для изменения и запись справочника Банки по переданным параметрам.
// Если такого банка ещё нет, то он создается.
// Если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей.
//
// Параметры:
//
// - Ссылки - Массив с элементами типа Структура - Ключи структуры - названия реквизитов справочника,
//   Значения структуры - значения данных реквизитов
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//   
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
&НаСервереБезКонтекста
Функция РаботаСБанкамиБП_СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение)
	
	МассивБанков = Новый Массив;
	
	Для инд = 0 По Ссылки.ВГраница() Цикл
		ПараметрыОбъект = Ссылки[инд];
		
		Банк = ПараметрыОбъект.Банк;
		
		Если ПараметрыОбъект.РучноеИзменение = 1
			И НЕ ИгнорироватьРучноеИзменение Тогда
			МассивБанков.Добавить(Банк);
			Продолжить;
		КонецЕсли;
		
		Если Банк.Пустая() Тогда
			Если ПараметрыОбъект.ЭтоРегион Тогда
				БанкОбъект = Справочники.Банки.СоздатьГруппу();
			Иначе
				БанкОбъект = Справочники.Банки.СоздатьЭлемент();
			КонецЕсли;
		Иначе
			БанкОбъект = Банк.ПолучитьОбъект();
		КонецЕсли;
		
		Если Не БанкОбъект.ЭтоГруппа Тогда
			ПараметрыОбъект.Вставить("Страна", Справочники.СтраныМира.Россия);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(БанкОбъект, ПараметрыОбъект);
		
		Если НЕ ПустаяСтрока(ПараметрыОбъект.РодительКод) И НЕ ЗначениеЗаполнено(ПараметрыОбъект.Родитель) Тогда
			Регион = Справочники.Банки.СсылкаНаБанк(ПараметрыОбъект.РодительКод, Истина);
			
			Если НЕ ЗначениеЗаполнено(Регион) Тогда
				ПараметрыБанковВышеПоИерархии = Новый Массив;
				ПараметрыБанковВышеПоИерархии.Добавить(РаботаСБанкамиБП_СсылкаПоКлассификатору(ПараметрыОбъект.РодительКод,, Истина));
				
				// Если переданный Родитель не является корневым элементом,
				// то будет возвращен массив всех элементов (групп) выше по иерархии.
				// В начале массива будет корневой элемент иерархии, в конце массива - элемента переданный в параметрах 
				МассивБанковВышеПоИерархии = РаботаСБанкамиБП_ПодобратьБанкИзКлассификатора(ПараметрыБанковВышеПоИерархии);
				
				Если МассивБанковВышеПоИерархии.Количество() > 0 Тогда
					// Переданный в параметре элемент (к созданию) в возвращенном Массиве будет всегда на последней позиции
					ПоследнийЭлемент = МассивБанковВышеПоИерархии.ВГраница();
					Регион = МассивБанковВышеПоИерархии[ПоследнийЭлемент];
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Регион) И Регион.ЭтоГруппа Тогда
				БанкОбъект.Родитель = Регион;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(БанкОбъект.Родитель) Тогда
				ШаблонСообщения = НСтр("en='Group is not defined for item  with code %1';ru='Не определена группа для элемента с кодом %1'");
				ТекстСообщения = СтрШаблон(
					ШаблонСообщения,
					СокрЛП(ПараметрыОбъект.Код));
				
				ЗаписьЖурналаРегистрации(
					НСтр("en='Banks classification';ru='Классификатор банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.Банки,
					Банк,
					ТекстСообщения);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			БанкОбъект.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ШаблонСообщения = НСтр("en='Failed to write element"
"%1';ru='Не удалось записать элемент"
"%1'");
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				НСтр("en='Banks classification';ru='Классификатор банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				Банк,
				ТекстСообщения);
			
			Прервать;
		КонецПопытки;
		
		МассивБанков.Добавить(БанкОбъект.Ссылка);
	КонецЦикла;
	
	Возврат МассивБанков;
	
КонецФункции

#КонецОбласти

#КонецОбласти