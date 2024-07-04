
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("РедактированиеРеквизитовОбъектов")
			И ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.уатНоменклатураГСМ) Тогда
		Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Видимость = Истина;
	Иначе 
		Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьЗапрещенныеРеквизиты();
	ЗаблокироватьЗапрещенныеРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьДоступность();
	УстановитьОтборыПоГСМ();
	//Элементы.ВестиУчетОстатковТЖ.Доступность = ДоступностьВестиУчетОстатковТЖ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Запись.ГруппаГСМ = ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Талон")
		И НЕ ЗначениеЗаполнено(Запись.ГСМТалона) Тогда
		
		Отказ = Истина;
		ТекстНСТР = НСтр("en='Not filled fuels info of coupon!';ru='Не заполнена номенклатура ГСМ талона!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР, 10);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаблокироватьЗапрещенныеРеквизиты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	УстановитьОтборыПоГСМ();
	//Элементы.ВестиУчетОстатковТЖ.Доступность = ДоступностьВестиУчетОстатковТЖ();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаГСМПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ГСМТалонаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры	 = Новый Структура("ЗначениеГСМДоИзменения, КлючУникальности", Запись.ГСМТалона, "ВыборГСМТалона");
	ОписаниеОповещенияЗакр	 = Новый ОписаниеОповещения("ОписаниеОповещенияВыбораГСМ", ЭтотОбъект, ДополнительныеПараметры);

	уатЗащищенныеФункцииКлиент.ВыбратьГСМ(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"), ДополнительныеПараметры, ОписаниеОповещенияЗакр);
КонецПроцедуры

&НаКлиенте
Процедура ГСМТалонаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	мсвГруппДляОтбора = Новый Массив;
	мсвГруппДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
	ДанныеВыбора = уатГСМ.ПолучитьСписокАвтоподбораПоляГСМ(Текст, мсвГруппДляОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ГСМТалонаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПараметрыПолученияДанных.СтрокаПоиска = "";
КонецПроцедуры

&НаКлиенте
Процедура ГСМТалонаОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Ключ", КлючЗаписиТалон());
	
	ОткрытьФорму("РегистрСведений.уатНоменклатураГСМ.ФормаЗаписи", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_АналогиГСМ

&НаКлиенте
Процедура АналогиГСМПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		Отказ = Истина;
		ТекстНСТР = НСтр("en='Not specified fuels info!';ru='Не указана номенклатура ГСМ!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР, 10);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналогиГСМПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекСтрока = Элементы.АналогиГСМ.ТекущиеДанные;
	Если (НЕ ОтменаРедактирования) И ЗначениеЗаполнено(Запись.Номенклатура) И Запись.Номенклатура = ТекСтрока.Аналог Тогда
		ТекстНСТР = НСтр("en='Fuels analog cannot be fuels itself!';ru='Аналогом ГСМ не может быть само ГСМ!'");
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ЦеныНоменклатурыКонтрегентов

&НаКлиенте
Процедура ЦеныНоменклатурыКонтрегентовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если НЕ ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		Отказ = Истина;
		ТекстНСТР = НСтр("en='Not specified fuels info!';ru='Не указана номенклатура ГСМ!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР, 10);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не ДоступностьВестиУчетОстатковТЖ() Тогда 
		ПоказатьПредупреждение(, НСтр("en='No blocked attributes.';ru='Нет заблокированных ревизитов.'"));
		Возврат;
	КонецЕсли;
	
	ЗаблокированныеРеквизиты = Новый Массив();
	РеквизитыПредставление = "";
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если Не ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда 
			ЗаблокированныеРеквизиты.Добавить(ОписаниеБлокируемогоРеквизита.ИмяРеквизита);
			РеквизитыПредставление = РеквизитыПредставление + ОписаниеБлокируемогоРеквизита.Представление + "," + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыПредставление = Лев(РеквизитыПредставление, СтрДлина(РеквизитыПредставление) - 2);
	
	Если ЗаблокированныеРеквизиты.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("en='Editing all visible object attributes allowed.';ru='Редактирование всех видимых реквизитов объекта уже разрешено.'"));
		Возврат;
	КонецЕсли;
	
	ЗаголовокДиалога = НСтр("en='Allow editing attributes';ru='Разрешение редактирования реквизитов'");
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("en='To prevent data inconsistency in the application,"
"the following attributes cannot be edited:"
"%1."
""
"It is recommended to review the effects before allowing their editing"
"by checking all usage locations of this item in the application."
"Usage location search may take a long time.';ru='Для того чтобы не допустить рассогласования данных в программе,"
"следующие реквизиты не доступны для редактирования:"
"%1."
""
"Перед тем, как разрешить их редактирование, рекомендуется оценить последствия,"
"проверив все места использования этого элемента в программе."
"Поиск мест использования может занять длительное время.'"),
		РеквизитыПредставление);
	
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("en='Check and allow';ru='Проверить и разрешить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("en='Cancel';ru='Отмена'"));
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ЗаблокированныеРеквизиты", ЗаблокированныеРеквизиты);
	ДопПараметры.Вставить("ЗаголовокДиалога",         ЗаголовокДиалога);
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПроверитьСсылкиНаОбъектПослеПодтвержденияПроверки", ЭтотОбъект, ДопПараметры),
		ТекстВопроса,
		Кнопки,
		, 
		КодВозвратаДиалога.Да, 
		ЗаголовокДиалога
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если Запись.ГруппаГСМ = ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Талон") Тогда
		Элементы.ЛитровыйТалон.Доступность = Истина;
		Элементы.НоминалТалона.Доступность = Истина;
		Элементы.ГСМТалона.Доступность = Истина;
		Элементы.ГСМТалона.АвтоОтметкаНезаполненного = Истина;
		Элементы.Плотность.Доступность = Ложь;
		Элементы.ГруппаАналоги.Доступность = Ложь;
		Элементы.ГруппаЦены.Доступность = Ложь;
	Иначе
		Элементы.ЛитровыйТалон.Доступность = Ложь;
		Элементы.НоминалТалона.Доступность = Ложь;
		Элементы.ГСМТалона.Доступность = Ложь;
		Элементы.Плотность.Доступность = Истина;
		Элементы.ГруппаАналоги.Доступность = Истина;
		Элементы.ГруппаЦены.Доступность = Истина;
	КонецЕсли;
	
	Элементы.ВестиУчетОстатковТЖ.Видимость = (Запись.ГруппаГСМ = ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.ПрисадкиИТехническиеЖидкости"));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоГСМ()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(АналогиГСМ.Отбор, "ГСМ", Запись.Номенклатура);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЦеныНоменклатурыКонтрегентов.Отбор, "Номенклатура",
		Запись.Номенклатура);
КонецПроцедуры

&НаСервере
Функция ДоступностьВестиУчетОстатковТЖ()
	
	Если Запись.ГруппаГСМ <> Перечисления.уатГруппыГСМ.ПрисадкиИТехническиеЖидкости Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Подключаемый динамически обработчик оповещения.
&НаКлиенте
Процедура ОписаниеОповещенияВыбораГСМ(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.ГСМТалона = Результат;
	
	Если Запись.ГСМТалона <> ДопПараметры.ЗначениеГСМДоИзменения Тогда 
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КлючЗаписиТалон()
	Возврат РегистрыСведений.уатНоменклатураГСМ.СоздатьКлючЗаписи(Новый Структура("Номенклатура", Запись.ГСМТалона));
КонецФункции

&НаСервере
Процедура ЗаполнитьЗапрещенныеРеквизиты()
	
	ОписаниеРеквизита = ПараметрыЗапретаРедактированияРеквизитов.Добавить();
	ОписаниеРеквизита.ИмяРеквизита = "ВестиУчетОстатковТЖ";
	ОписаниеРеквизита.Представление = НСтр("en='Keep record of liquids remains';ru='Вести учет остатков ТЖ'");
	ОписаниеРеквизита.БлокируемыеЭлементы.Добавить("ВестиУчетОстатковТЖ");
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьЗапрещенныеРеквизиты()
	
	ЭтоНовыйОбъект = Параметры.Ключ.Пустой();
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из ПараметрыЗапретаРедактированияРеквизитов Цикл
		Для Каждого ОписаниеЭлементаФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
			ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено = ЭтоНовыйОбъект;
			
			ЭлементФормы = Элементы.Найти(ОписаниеЭлементаФормы.Значение);
			Если ЭлементФормы <> Неопределено Тогда
				Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
					Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
					ЭлементФормы.ТолькоПросмотр = Не ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено;
				Иначе
					ЭлементФормы.Доступность = ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Элементы.Найти("РазрешитьРедактированиеРеквизитовОбъекта") <> Неопределено Тогда
		Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСсылкиНаОбъектПослеПодтвержденияПроверки(Ответ, ДопПараметры) Экспорт
	
	Если Не Ответ = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ЕстьСсылкиНаТЖ() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("en='Item ""%1"" is already used in other parts of the application."
"It is not recommended to allow editing due to risk of data inconsistency.';ru='Элемент ""%1"" уже используется в других местах в программе."
"Не рекомендуется разрешать редактирование из-за риска рассогласования данных.'"),
			Запись.Номенклатура);
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да,  НСтр("en='Enable editing';ru='Разрешить редактирование'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("en='Cancel';ru='Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПроверитьСсылкиНаОбъектПослеПодтвержденияРедактирования", ЭтотОбъект, ДопПараметры),
			ТекстСообщения,
			Кнопки, 
			, 
			КодВозвратаДиалога.Нет, 
			ДопПараметры.ЗаголовокДиалога
		);
		
	Иначе
		РазрешитьРедактированиеРеквизитовОбъектаПослеПроверкиСсылок(Истина, ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСсылкиНаОбъектПослеПодтвержденияРедактирования(Ответ, ДопПараметры) Экспорт
	
	РазрешитьРедактированиеРеквизитовОбъектаПослеПроверкиСсылок(Ответ = КодВозвратаДиалога.Да, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаПослеПроверкиСсылок(Результат, ДопПараметры)
	
	Если Результат Тогда
		УстановитьРазрешенностьРедактированияРеквизитов(ДопПараметры.ЗаблокированныеРеквизиты);
		УстановитьДоступностьЭлементовФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешенностьРедактированияРеквизитов(Знач РазблокированныеРеквизиты)
	
	Если ТипЗнч(РазблокированныеРеквизиты) = Тип("Массив") Тогда
		Для Каждого Реквизит Из РазблокированныеРеквизиты Цикл
			ОписаниеРеквизита = ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(Новый Структура("ИмяРеквизита", Реквизит))[0];
			ОписаниеРеквизита.РедактированиеРазрешено = Истина;
		КонецЦикла;
	КонецЕсли;
	
	// Обновление доступности команды РазрешитьРедактированиеРеквизитовОбъекта.
	ВсеРеквизитыРазблокированы = Истина;
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если Не ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			ВсеРеквизитыРазблокированы = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ВсеРеквизитыРазблокированы Тогда
		Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Доступность = Ложь;
		ОбновитьОтображениеДанных();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			Для Каждого БлокируемыйЭлементФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
				ЭлементФормы = Элементы.Найти(БлокируемыйЭлементФормы.Значение);
				Если ЭлементФормы <> Неопределено Тогда
					Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы")
					   И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
					 Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
						ЭлементФормы.ТолькоПросмотр = Ложь;
					Иначе
						ЭлементФормы.Доступность = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаСервере
Функция ЕстьСсылкиНаТЖ()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекНоменклатура", Запись.Номенклатура);
	
	ТипНоменклатура = ТипЗнч(Справочники.Номенклатура.ПустаяСсылка());
	
	Для Каждого РегистрНакопления Из Метаданные.РегистрыНакопления Цикл
		Для Каждого РеквизитРегистра Из РегистрНакопления.Измерения Цикл
			Если РеквизитРегистра.Тип.СодержитТип(ТипНоменклатура) Тогда
				Если Запрос.Текст <> "" Тогда
					Запрос.Текст = Запрос.Текст + "
					|ОБЪЕДИНИТЬ ВСЕ
					|";
				КонецЕсли;
				Запрос.Текст = Запрос.Текст + "
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	РегистрНакопления."+РегистрНакопления.Имя+"."+РеквизитРегистра.Имя+" КАК Номенклатура
				|ГДЕ
				|	"+РеквизитРегистра.Имя+" = &ТекНоменклатура
				|";
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	НетСсылкиНаТЖ = Запрос.Выполнить().Пустой();
	
	Возврат Не НетСсылкиНаТЖ;
	
КонецФункции

#КонецОбласти
