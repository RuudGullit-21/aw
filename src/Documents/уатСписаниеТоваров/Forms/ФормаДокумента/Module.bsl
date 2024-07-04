
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	уатОбщегоНазначенияСервер.НастроитьПолеЕдиницыИзмерения(ЭтотОбъект, "Товары");
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.Подразделение, "Объект.Организация");
	
	//ПодключаемоеОборудование
	уатОбщегоНазначения_проф.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	//Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// уатУправлениеАвтотранспортом.МодификацияКонфигурации
	уатМодификацияКонфигурацииКлиентПереопределяемый.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец уатУправлениеАвтотранспортом.МодификацияКонфигурации
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект);
	//Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Обработка.уатПодборНоменклатуры.Форма.Форма" или ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаПодбора(ИсточникВыбора.ИмяТаблицы, ВыбранноеЗначение);
	ИначеЕсли   ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументЗакупки.Форма.Форма" Тогда
		ОбработкаПодбора("Товары", ВыбранноеЗначение);
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Оповещ = Новый ОписаниеОповещения("ДобавитьНоменклатуруВТЧПоШтрихкоду", ЭтотОбъект);
		уатОбщегоНазначенияКлиент.ОбработатьСобытиеПодключаемогоОборудования(ИмяСобытия, Параметр, Источник,
			Новый Структура("Оповещение", Оповещ));
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	// ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Объект.Организация,
		ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ")) Тогда
		
		ТекстНСТР = НСтр("en='For company ""%1"" the possibility of inventory management with FMS documents is disabled!';ru='Для организации ""%1"" отключена возможность ведения складского учета документами УАТ!'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, Объект.Организация);
		ПоказатьПредупреждение(Неопределено, ТекстНСТР, 5);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризацияТоваровНаСкладеПриИзменении(Элемент)
	ПриИзмененииИнвентаризацииТоваровНаСкладе();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура",	 СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) тогда
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатОбщегоНазначенияКлиент.ТЧТоварыЕдиницаИзмеренияНачалоВыбора(
		Элементы.Товары.ТекущиеДанные.Номенклатура, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ТоварыПодбор(Команда)
	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		уатОбщегоНазначенияТиповыеКлиент.уатОткрытьПодборНоменклатуры(ЭтотОбъект,ПараметрыПодбора,УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИнвентаризации(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.ИнвентаризацияТоваровНаСкладе) Тогда
		ТекстНСТР = НСтр("en='Not specified document ""Inventory""';ru='Не указан документ ""Инвентаризация""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,, "ИнвентаризацияТоваровНаСкладе", "Объект");
		Возврат;
	КонецЕсли;
	Если Объект.Товары.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоИнвентаризацииЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, );
	Иначе
		ЗаполнитьПоИнвентаризацииСервер();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	Оповещ = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ПоказатьВводЗначения(Оповещ, "", "Введите штрихкод номенклатуры", Тип("Строка"));
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ТекНоменклатура = уатЗащищенныеФункцииСервер_проф.ПолучитьОбъектПоШтрихкоду(Результат);
		ДобавитьНоменклатуруВТЧПоШтрихкоду(Новый Структура("Штрихкод, Объект", Результат, ТекНоменклатура));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
// Выполняет необходимые действия при изменении реквизита ИнвентаризацияТоваровНаСкладе
//
Процедура ПриИзмененииИнвентаризацииТоваровНаСкладе() 
	
	Если ЗначениеЗаполнено(Объект.ИнвентаризацияТоваровНаСкладе) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.ИнвентаризацияТоваровНаСкладе, "Организация");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
			Объект.Склад = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.ИнвентаризацияТоваровНаСкладе, "Склад");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаХраненияОстатков);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора)
	
	Если ЗначениеВыбора.Свойство("АдресПодобраннойНоменклатурыВХранилище") Тогда
		МассивТоваров = ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора.АдресПодобраннойНоменклатурыВХранилище);
	Иначе
		МассивТоваров = ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора.АдресТоваровВХранилище);
	КонецЕсли;
	
	Для Каждого ТекСтрока из МассивТоваров Цикл
		
		
		СтруктураОтбора = Новый Структура();
		
		СтруктураОтбора.Вставить("Номенклатура",     ТекСтрока.Номенклатура);
		СтруктураОтбора.Вставить("ЕдиницаИзмерения", ТекСтрока.ЕдиницаИзмерения);
		
		МассивСтрок = Объект.Товары.НайтиСтроки(СтруктураОтбора);
		Если МассивСтрок.Количество() = 0 Тогда
			СтрокаТабличнойЧасти = Неопределено;
		Иначе
			СтрокаТабличнойЧасти = МассивСтрок[0];
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			// Нашли, увеличиваем количество в первой найденной строке.
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество +   ТекСтрока.Количество;
			//РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
		Иначе
			// Не нашли - добавляем новую строку.
			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура	  = ТекСтрока.Номенклатура;
			СтрокаТабличнойЧасти.Количество  	  = ТекСтрока.Количество;
			СтрокаТабличнойЧасти.ЕдиницаИзмерения =  ТекСтрока.ЕдиницаИзмерения;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры //

&НаКлиенте
Процедура ЗаполнитьПоИнвентаризацииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    ЗаполнитьПоИнвентаризацииСервер();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоИнвентаризацииСервер()
	Если НЕ ЗначениеЗаполнено(Объект.ИнвентаризацияТоваровНаСкладе) Тогда
		Возврат;
	КонецЕсли;	
	
	Если Объект.Товары.Количество() > 0 Тогда
				
		Объект.Товары.Очистить();
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДокументСсылка",          Объект.Ссылка);
	Запрос.УстановитьПараметр("ДокументОснованиеСсылка", Объект.ИнвентаризацияТоваровНаСкладе);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(Док.НомерСтроки) КАК НомерСтроки,
	|	Док.Номенклатура,
	|	Док.ЕдиницаИзмерения,
	|	Док.Ссылка.Склад                              КАК Склад,
	|	МАКСИМУМ(Док.КоличествоУчет - Док.Количество) КАК КоличествоОтклонение,
	|	ВЫБОР
	|		КОГДА СУММА(ВложенныйЗапрос.Количество) ЕСТЬ NULL ТОГДА
	|			0
	|		ИНАЧЕ
	|			СУММА(ВложенныйЗапрос.Количество)
	|	КОНЕЦ КАК КоличествоСписанное
	|ИЗ
	|	Документ.уатИнвентаризацияТоваров.Товары КАК Док
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	(ВЫБРАТЬ 
	|       ДокСписание.Номенклатура,
	|       ДокСписание.Ссылка.Склад КАК Склад,
	|		ДокСписание.Количество КАК Количество
	|	 ИЗ
	|       Документ.уатСписаниеТоваров.Товары КАК ДокСписание
	|    ГДЕ
	|       ДокСписание.Ссылка <> &ДокументСсылка
	|       И ДокСписание.Ссылка.Проведен
	|       И ДокСписание.Ссылка.ИнвентаризацияТоваровНаСкладе = &ДокументОснованиеСсылка
	|	) КАК ВложенныйЗапрос
	|ПО
	|	Док.Номенклатура = ВложенныйЗапрос.Номенклатура И Док.Ссылка.Склад = ВложенныйЗапрос.Склад
	|
	|ГДЕ
	|	  Док.Ссылка = &ДокументОснованиеСсылка 
	|   И Док.КоличествоУчет - Док.Количество > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Док.Ссылка.Склад,
	|	Док.Номенклатура,
	|	Док.ЕдиницаИзмерения
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Склад = Объект.ИнвентаризацияТоваровНаСкладе.Склад;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		КоличествоСписать = Выборка.КоличествоОтклонение - Выборка.КоличествоСписанное;
		
		Если КоличествоСписать <= 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		СтрокаТабличнойЧасти.Номенклатура     = Выборка.Номенклатура;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
		СтрокаТабличнойЧасти.Количество       = КоличествоСписать;
		
	КонецЦикла;
	
	#Если Клиент Тогда
		
		Если Объект.Товары.Количество() = 0 Тогда
			ТекстНСТР = НСтр("en='In document ""%1"" has no goods account whose number is larger than the actual.';ru='В документе ""%1"" отсутствуют товары учетное количество которых превышает фактическое.'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, Объект.ИнвентаризацияТоваровНаСкладе);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР);
		КонецЕсли;
		
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	
	ЗаголовокПодбора = НСтр("en='Selection products and services in %1 (%2)';ru='Подбор номенклатуры в %1 (%2)'");
	ПредставлениеТаблицы = НСтр("en='Goods';ru='Товары'");
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, НСтр("en='Goods';ru='Товары'"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказыватьЦены", Ложь);
	ПараметрыФормы.Вставить("ЕстьЦена"      , Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	//ПараметрыФормы.Вставить("Валюта"        , ВалютаУпрУчета);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ПоказыватьСчетУчета", Истина);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)

	ВидПодбора = "";
	
	Возврат ВидПодбора;

КонецФункции

&НаСервере 
Функция ПолучитьТоварыИзВременногоХранилища(ЗначениеВыбора)
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ЗначениеВыбора);
	МассивТоваров = Новый Массив;
	Для Каждого ТекСтрока Из ТаблицаТоваров Цикл
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура",		 ТекСтрока.Номенклатура);
		Структура.Вставить("ЕдиницаИзмерения",	 ТекСтрока.Номенклатура.ЕдиницаХраненияОстатков);
		Структура.Вставить("Количество",		 ТекСтрока.Количество);
		Структура.Вставить("Цена",				 ТекСтрока.Цена);
		МассивТоваров.Добавить(Структура);
	КонецЦикла;
	
	Возврат МассивТоваров;
КонецФункции

&НаКлиенте
Процедура ДобавитьНоменклатуруВТЧПоШтрихкоду(Результат, ДопПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Результат.Объект)
		ИЛИ ТипЗнч(Результат.Объект) <> Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат;
	КонецЕсли;
	Номенклатура = Результат.Объект;
	
	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура));
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, увеличиваем количество в первой найденной строке.
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + 1;
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект.Товары.Добавить();
		СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
			СтрокаТабличнойЧасти.Номенклатура, "ЕдиницаХраненияОстатков");
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
